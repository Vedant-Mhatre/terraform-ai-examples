# Cross-Account Terraform Deploy Role

This example creates an IAM role in a target account that a CI/CD role in another account can assume.

## Why This Is Useful

Most teams run Terraform from a centralized build account but deploy into separate workload accounts. This is the baseline trust and permission pattern.

## Usage

```bash
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan
terraform apply
```

## Security Notes

- Keep `external_id` secret and rotate periodically.
- Prefer `allow_admin_access = false` and tighten scoped permissions over time.
- Limit `trusted_principal_arns` to exact CI role ARNs.
