# SageMaker Distributed GPU Training

Launch a reproducible distributed training job for large-model fine-tuning with private networking, spot support, and checkpoint recovery.

## Architecture

![SageMaker Distributed Training Architecture](./architecture.svg)

## What You'll Learn

- How to define a multi-node SageMaker training job with Terraform.
- How to reduce training cost using managed spot + checkpointing.
- How to isolate training workloads in private subnets with restricted IAM.

## Real-World Use Case

Used by ML platform teams running recurring fine-tuning jobs where cost and reliability both matter. This pattern helps recover from spot interruptions instead of restarting multi-hour training from scratch.

## Usage

```bash
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan
```

By default, `enable_training_job = false` to avoid accidental GPU spend. Launch intentionally:

```bash
terraform apply -var='enable_training_job=true'
```

## Validation Steps

1. Confirm role and artifact bucket outputs:

```bash
terraform output sagemaker_execution_role_arn
terraform output artifact_bucket_name
```

2. If training was enabled, verify the job exists:

```bash
aws sagemaker describe-training-job --training-job-name "$(terraform output -raw training_job_name)"
```

3. Confirm checkpoints or output artifacts appear in the artifact bucket.

## Cost and Safety

- Estimated cost risk: very high (GPU training instances dominate cost).
- Most expensive knobs: `instance_type`, `instance_count`, and runtime limits.
- Built-in guardrails: `enable_training_job` switch, runtime/max-wait controls, managed spot option.

## Cleanup

```bash
terraform destroy
```

If you kept artifacts intentionally, empty the bucket manually only when you are done with checkpoints/model outputs.

## Next Improvements

- Add CloudWatch alarms for failed or prolonged training jobs.
- Add experiment tracking integration (for example, MLflow/W&B metadata sidecar).
- Add per-team quota controls for instance families.
