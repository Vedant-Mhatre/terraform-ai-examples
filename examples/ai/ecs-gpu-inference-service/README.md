# ECS GPU Inference Service

Deploy a GPU-backed inference service on ECS EC2 with ALB routing, service autoscaling, and an explicit host capacity layer.

## Architecture

![ECS GPU Inference Architecture](./architecture.svg)

## What You'll Learn

- How to run GPU inference on ECS with EC2 capacity providers.
- How ALB + target groups + task networking fit together.
- How to combine host autoscaling and service autoscaling safely.

## Real-World Use Case

Useful when teams need more runtime control than managed endpoints provide, including custom CUDA stacks, model server tuning, and integration with internal platform networking.

## Usage

```bash
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan
terraform apply
```

Set `acm_certificate_arn` in `terraform.tfvars` to a valid ACM certificate in the same region as the ALB.

## Validation Steps

1. Check ECS resources:

```bash
terraform output ecs_cluster_name
terraform output ecs_service_name
```

2. Verify endpoint health:

```bash
curl -i "https://$(terraform output -raw alb_dns_name)/healthz"
```

3. Verify ECS tasks are placed on GPU hosts and passing health checks.

## System Design Sizing

Assume:
- target p95 latency budget: 250 ms
- one GPU task sustains ~8 RPS at ~70% GPU utilization
- `gpus_per_task = 1`, `gpu_instance_type = g5.2xlarge` (1 GPU/host)
- `service_desired_count = 2`, `asg_desired_size = 2`

Capacity math:
- service capacity ~= `tasks * rps_per_task` = `2 * 8` = `16 RPS` baseline
- required hosts ~= `ceil((desired_tasks * gpus_per_task) / gpus_per_host)`
- for 6 desired tasks with 1 GPU/task and 1 GPU/host: `ceil(6/1) = 6 hosts`

Latency budget split (example):
- ALB + network: 35 ms
- model inference: 180 ms
- serialization + response: 35 ms
- total: 250 ms

Failure-budget style check:
- if peak is 40 RPS, baseline 16 RPS is not enough
- needed tasks at 8 RPS/task: `ceil(40/8) = 5 tasks`
- with this instance type, keep ASG max >= 5 to avoid prolonged `PENDING` tasks

## Incident Simulation

- Runbook: `../../../docs/incidents/ai-ecs-gpu-inference-service.md`

## Cost and Safety

- Estimated cost risk: high (`g5`/`p` family pricing + always-on instances).
- Most expensive knobs: `gpu_instance_type`, ASG desired capacity, service task count.
- Built-in guardrails: explicit autoscaling bounds and separate host/task scaling controls.

## Cleanup

```bash
terraform destroy
```

## Next Improvements

- Add request-rate and latency-based autoscaling policy.
- Add blue/green deployment strategy (CodeDeploy or dual target groups).
