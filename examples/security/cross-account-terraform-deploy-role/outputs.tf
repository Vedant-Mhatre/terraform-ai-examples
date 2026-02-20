output "deploy_role_arn" {
  description = "ARN of the cross-account Terraform deploy role."
  value       = aws_iam_role.deploy.arn
}

output "assume_role_snippet" {
  description = "Use this in your Terraform provider config in the CI/CD account."
  value = <<-EOT
    provider "aws" {
      region = "${var.region}"
      assume_role {
        role_arn    = "${aws_iam_role.deploy.arn}"
        external_id = "${var.external_id}"
      }
    }
  EOT
}
