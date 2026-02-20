locals {
  role_name = "${var.name_prefix}-${var.environment}"
}

resource "aws_iam_role" "deploy" {
  name                 = local.role_name
  max_session_duration = var.max_session_duration_seconds

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          AWS = var.trusted_principal_arns
        }
        Condition = {
          StringEquals = {
            "sts:ExternalId" = var.external_id
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "admin" {
  count = var.allow_admin_access ? 1 : 0

  role       = aws_iam_role.deploy.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_policy" "scoped" {
  count = var.allow_admin_access ? 0 : 1

  name        = "${local.role_name}-scoped"
  description = "Scoped policy for Terraform deployment actions"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = concat(
      [
        {
          Sid    = "TerraformCommonInfraWrite"
          Effect = "Allow"
          Action = [
            "ec2:*",
            "elasticloadbalancing:*",
            "autoscaling:*",
            "ecs:*",
            "ecr:*",
            "logs:*",
            "cloudwatch:*",
            "events:*",
            "sns:*",
            "sqs:*",
            "lambda:*",
            "rds:*",
            "s3:*",
            "dynamodb:*",
            "kms:*",
            "iam:Get*",
            "iam:List*",
            "iam:CreateRole",
            "iam:DeleteRole",
            "iam:UpdateRole",
            "iam:AttachRolePolicy",
            "iam:DetachRolePolicy",
            "iam:PutRolePolicy",
            "iam:DeleteRolePolicy",
            "iam:PassRole",
            "iam:TagRole",
            "iam:UntagRole",
            "sagemaker:*",
            "batch:*"
          ]
          Resource = "*"
        }
      ],
      var.state_bucket_arn != "" ? [
        {
          Sid    = "TerraformStateBucketAccess"
          Effect = "Allow"
          Action = [
            "s3:GetObject",
            "s3:PutObject",
            "s3:DeleteObject",
            "s3:ListBucket"
          ]
          Resource = [
            var.state_bucket_arn,
            "${var.state_bucket_arn}/*"
          ]
        }
      ] : [],
      var.lock_table_arn != "" ? [
        {
          Sid    = "TerraformLockTableAccess"
          Effect = "Allow"
          Action = [
            "dynamodb:DescribeTable",
            "dynamodb:GetItem",
            "dynamodb:PutItem",
            "dynamodb:DeleteItem"
          ]
          Resource = var.lock_table_arn
        }
      ] : []
    )
  })
}

resource "aws_iam_role_policy_attachment" "scoped" {
  count = var.allow_admin_access ? 0 : 1

  role       = aws_iam_role.deploy.name
  policy_arn = aws_iam_policy.scoped[0].arn
}
