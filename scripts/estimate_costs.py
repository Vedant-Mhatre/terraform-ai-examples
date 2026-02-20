#!/usr/bin/env python3
"""Estimate monthly costs for repository examples using simple assumptions.

This is a planning aid, not a billing-grade calculator.
"""

from __future__ import annotations

import argparse
import json
import re
from pathlib import Path
from typing import Any, Dict

HOURS_PER_MONTH = 730

EC2_GPU_HOURLY_USD = {
    "g4dn.xlarge": 0.526,
    "g5.xlarge": 1.006,
    "g5.2xlarge": 1.212,
    "g5.4xlarge": 1.624,
    "g5.8xlarge": 2.448,
    "p3.2xlarge": 3.06,
    "p4d.24xlarge": 32.77,
    "p5.48xlarge": 98.32,
}

SAGEMAKER_TRAINING_HOURLY_USD = {
    "ml.g5.12xlarge": 5.672,
    "ml.g5.24xlarge": 10.888,
    "ml.p3.16xlarge": 24.48,
    "ml.p4d.24xlarge": 32.77,
    "ml.p5.48xlarge": 98.32,
}


def parse_tfvars(path: Path) -> Dict[str, Any]:
    values: Dict[str, Any] = {}
    assign_pattern = re.compile(r"^([A-Za-z_][A-Za-z0-9_]*)\s*=\s*(.+)$")

    for raw_line in path.read_text(encoding="utf-8").splitlines():
        line = raw_line.strip()
        if not line or line.startswith("#"):
            continue

        # Drop inline comment suffix for simple assignments.
        if "#" in line:
            line = line.split("#", 1)[0].strip()

        match = assign_pattern.match(line)
        if not match:
            continue

        key, raw_val = match.group(1), match.group(2).strip().rstrip(",")

        if raw_val.startswith('"') and raw_val.endswith('"'):
            values[key] = raw_val[1:-1]
            continue

        if raw_val in {"true", "false"}:
            values[key] = raw_val == "true"
            continue

        if re.fullmatch(r"-?\d+", raw_val):
            values[key] = int(raw_val)
            continue

        if re.fullmatch(r"-?\d+\.\d+", raw_val):
            values[key] = float(raw_val)
            continue

    return values


def money(value: float) -> str:
    return f"${value:,.2f}"


def estimate_ecs_gpu(values: Dict[str, Any]) -> Dict[str, Any]:
    instance_type = str(values.get("gpu_instance_type", "g5.xlarge"))
    desired_hosts = int(values.get("asg_desired_size", 1))
    hourly = EC2_GPU_HOURLY_USD.get(instance_type, EC2_GPU_HOURLY_USD["g5.xlarge"])

    ec2_hosts = hourly * desired_hosts * HOURS_PER_MONTH
    ebs_gp3 = desired_hosts * 150 * 0.08
    alb = 25.0
    logs = 12.0

    total = ec2_hosts + ebs_gp3 + alb + logs

    return {
        "example": "ecs-gpu-inference-service",
        "assumptions": {
            "instance_type": instance_type,
            "desired_hosts": desired_hosts,
            "hours_per_month": HOURS_PER_MONTH,
        },
        "line_items": {
            "gpu_hosts": ec2_hosts,
            "host_ebs_gp3": ebs_gp3,
            "alb_and_lcu": alb,
            "cloudwatch_logs": logs,
        },
        "monthly_total_usd": total,
    }


def estimate_sagemaker_training(values: Dict[str, Any], training_hours_per_month: float) -> Dict[str, Any]:
    instance_type = str(values.get("instance_type", "ml.g5.12xlarge"))
    instance_count = int(values.get("instance_count", 1))
    use_spot = bool(values.get("use_spot_instances", True))

    on_demand_hourly = SAGEMAKER_TRAINING_HOURLY_USD.get(
        instance_type, SAGEMAKER_TRAINING_HOURLY_USD["ml.g5.12xlarge"]
    )
    effective_hourly = on_demand_hourly * (0.35 if use_spot else 1.0)

    compute = effective_hourly * instance_count * training_hours_per_month
    artifacts = 30.0
    logs = 8.0

    total = compute + artifacts + logs

    return {
        "example": "sagemaker-distributed-training",
        "assumptions": {
            "instance_type": instance_type,
            "instance_count": instance_count,
            "training_hours_per_month": training_hours_per_month,
            "spot_discount_applied": use_spot,
        },
        "line_items": {
            "training_compute": compute,
            "artifact_storage": artifacts,
            "cloudwatch_logs": logs,
        },
        "monthly_total_usd": total,
        "note": "If you disable spot usage, compute cost can increase materially.",
    }


def estimate_ingestion_pipeline(
    values: Dict[str, Any],
    events_per_month: int,
    lambda_avg_duration_ms: int,
) -> Dict[str, Any]:
    memory_mb = int(values.get("lambda_memory_mb", 512))
    memory_gb = memory_mb / 1024

    lambda_requests = (events_per_month / 1_000_000) * 0.20
    gb_seconds = events_per_month * (lambda_avg_duration_ms / 1000.0) * memory_gb
    lambda_compute = gb_seconds * 0.0000166667

    sqs_requests_millions = (events_per_month * 2) / 1_000_000
    sqs = sqs_requests_millions * 0.40

    s3_puts = ((events_per_month * 2) / 1000.0) * 0.005
    alarms_and_logs = 10.0

    total = lambda_requests + lambda_compute + sqs + s3_puts + alarms_and_logs

    return {
        "example": "event-driven-ingestion-pipeline",
        "assumptions": {
            "events_per_month": events_per_month,
            "lambda_memory_mb": memory_mb,
            "lambda_avg_duration_ms": lambda_avg_duration_ms,
        },
        "line_items": {
            "lambda_requests": lambda_requests,
            "lambda_compute": lambda_compute,
            "sqs_requests": sqs,
            "s3_put_requests": s3_puts,
            "alarms_and_logs": alarms_and_logs,
        },
        "monthly_total_usd": total,
    }


def estimate_state_backend(values: Dict[str, Any], state_size_gb: float) -> Dict[str, Any]:
    s3_storage = state_size_gb * 0.023
    dynamodb = 1.5
    kms = 1.0

    total = s3_storage + dynamodb + kms

    return {
        "example": "hardened-terraform-state-backend",
        "assumptions": {
            "state_size_gb": state_size_gb,
        },
        "line_items": {
            "s3_state_storage": s3_storage,
            "dynamodb_lock_table": dynamodb,
            "kms_usage": kms,
        },
        "monthly_total_usd": total,
    }


def estimate_cross_account_role(values: Dict[str, Any]) -> Dict[str, Any]:
    # IAM role itself has no direct monthly cost.
    return {
        "example": "cross-account-terraform-deploy-role",
        "assumptions": {
            "allow_admin_access": bool(values.get("allow_admin_access", False)),
        },
        "line_items": {
            "iam_role": 0.0,
            "policy_attachments": 0.0,
        },
        "monthly_total_usd": 0.0,
        "note": "Primary risk is security misconfiguration, not infrastructure spend.",
    }


def print_human(result: Dict[str, Any]) -> None:
    print(f"Example: {result['example']}")
    print("Assumptions:")
    for key, value in result["assumptions"].items():
        print(f"  - {key}: {value}")

    print("Line items:")
    for key, value in result["line_items"].items():
        print(f"  - {key}: {money(float(value))}")

    print(f"Estimated monthly total: {money(float(result['monthly_total_usd']))}")
    if "note" in result:
        print(f"Note: {result['note']}")


def main() -> None:
    parser = argparse.ArgumentParser(description="Estimate monthly costs for terraform-ai-examples.")
    parser.add_argument("--example", required=True, choices=[
        "ecs-gpu-inference-service",
        "sagemaker-distributed-training",
        "event-driven-ingestion-pipeline",
        "hardened-terraform-state-backend",
        "cross-account-terraform-deploy-role",
    ])
    parser.add_argument("--tfvars", type=Path, required=True, help="Path to tfvars or terraform.tfvars.example file.")
    parser.add_argument("--training-hours-per-month", type=float, default=40.0)
    parser.add_argument("--events-per-month", type=int, default=1_000_000)
    parser.add_argument("--lambda-avg-duration-ms", type=int, default=300)
    parser.add_argument("--state-size-gb", type=float, default=5.0)
    parser.add_argument("--json", action="store_true", help="Print JSON output.")

    args = parser.parse_args()

    values = parse_tfvars(args.tfvars)

    if args.example == "ecs-gpu-inference-service":
        result = estimate_ecs_gpu(values)
    elif args.example == "sagemaker-distributed-training":
        result = estimate_sagemaker_training(values, args.training_hours_per_month)
    elif args.example == "event-driven-ingestion-pipeline":
        result = estimate_ingestion_pipeline(values, args.events_per_month, args.lambda_avg_duration_ms)
    elif args.example == "hardened-terraform-state-backend":
        result = estimate_state_backend(values, args.state_size_gb)
    else:
        result = estimate_cross_account_role(values)

    if args.json:
        print(json.dumps(result, indent=2))
    else:
        print_human(result)


if __name__ == "__main__":
    main()
