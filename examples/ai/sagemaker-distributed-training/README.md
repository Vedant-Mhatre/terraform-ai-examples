# SageMaker Distributed GPU Training

This example models a realistic foundation-model fine-tuning stack:
- isolated VPC networking
- managed spot training for cost control
- checkpointing and output artifacts in encrypted S3
- explicit switch to avoid accidental expensive runs

## Why This Is Useful

Teams usually need more than "hello world" SageMaker. This layout is suitable for:
- multi-node training and periodic re-training
- cost-aware experimentation with spot
- reproducible training job definitions for CI/CD

## Usage

```bash
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan
```

Launch the job only when ready:

```bash
terraform apply -var='enable_training_job=true'
```

## Notes

- Update `training_image_uri` to your ECR image.
- Update `s3_training_data_uri` to your dataset location.
- For very large runs, use `ml.p4d`/`ml.p5` families and increase volume/runtime.
