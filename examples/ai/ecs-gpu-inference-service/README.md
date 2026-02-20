# ECS GPU Inference Service

This example deploys a production-style inference service with:
- ECS cluster on GPU EC2 instances
- ALB front door
- ECS capacity provider + ASG for host scaling
- service-level autoscaling based on CPU utilization

## Architecture

![ECS GPU Inference Architecture](./architecture.svg)

## Why This Is Useful

It mirrors common self-managed inference stacks where teams need:
- tighter control of container/runtime than managed endpoints
- GPU host tuning and custom drivers/runtime behavior
- integration with existing VPCs and internal platform patterns

## Usage

```bash
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan
terraform apply
```

After apply, hit `http://<alb_dns_name>/healthz`.

## Cost Notes

- `g5`/`p` family instances are expensive. Keep `asg_desired_size` low for dev.
- Scale down to zero only if you can tolerate cold starts and re-scheduling delays.
