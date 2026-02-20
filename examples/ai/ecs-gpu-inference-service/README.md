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

## Validation Steps

1. Check ECS resources:

```bash
terraform output ecs_cluster_name
terraform output ecs_service_name
```

2. Verify endpoint health:

```bash
curl -i "http://$(terraform output -raw alb_dns_name)/healthz"
```

3. Verify ECS tasks are placed on GPU hosts and passing health checks.

## Cost and Safety

- Estimated cost risk: high (`g5`/`p` family pricing + always-on instances).
- Most expensive knobs: `gpu_instance_type`, ASG desired capacity, service task count.
- Built-in guardrails: explicit autoscaling bounds and separate host/task scaling controls.

## Cleanup

```bash
terraform destroy
```

## Next Improvements

- Add HTTPS listener + ACM certificate for production traffic.
- Add request-rate and latency-based autoscaling policy.
- Add blue/green deployment strategy (CodeDeploy or dual target groups).
