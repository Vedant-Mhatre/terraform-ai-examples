data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

locals {
  training_data_path  = replace(var.s3_training_data_uri, "s3://", "")
  training_data_parts = split("/", local.training_data_path)
  training_bucket     = local.training_data_parts[0]
  training_prefix     = length(local.training_data_parts) > 1 ? join("/", slice(local.training_data_parts, 1, length(local.training_data_parts))) : ""

  output_bucket_name = var.model_artifact_bucket_name != "" ? var.model_artifact_bucket_name : "${var.name_prefix}-${data.aws_caller_identity.current.account_id}-${var.region}-artifacts"
  output_prefix      = "output"
  checkpoint_prefix  = "checkpoints"
  computed_job_name  = var.training_job_name != "" ? var.training_job_name : "${var.name_prefix}-${var.environment}"
}

resource "aws_s3_bucket" "artifacts" {
  bucket        = local.output_bucket_name
  force_destroy = false
}

resource "aws_s3_bucket_versioning" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = var.kms_key_id != "" ? "aws:kms" : "AES256"
      kms_master_key_id = var.kms_key_id != "" ? var.kms_key_id : null
    }
  }
}

resource "aws_s3_bucket_public_access_block" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_security_group" "training" {
  name        = "${var.name_prefix}-sagemaker-${var.environment}"
  description = "Security group for isolated SageMaker training."
  vpc_id      = var.vpc_id

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name_prefix}-sagemaker-sg"
  }
}

resource "aws_iam_role" "sagemaker_execution" {
  name = "${var.name_prefix}-sagemaker-exec-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "sagemaker.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "sagemaker_execution" {
  name = "${var.name_prefix}-sagemaker-exec-policy"
  role = aws_iam_role.sagemaker_execution.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:${data.aws_partition.current.partition}:s3:::${local.training_bucket}",
          local.training_prefix != "" ? "arn:${data.aws_partition.current.partition}:s3:::${local.training_bucket}/${local.training_prefix}*" : "arn:${data.aws_partition.current.partition}:s3:::${local.training_bucket}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.artifacts.arn,
          "${aws_s3_bucket.artifacts.arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchCheckLayerAvailability"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ec2:CreateNetworkInterface",
          "ec2:DeleteNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeVpcs"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_sagemaker_training_job" "distributed" {
  count = var.enable_training_job ? 1 : 0

  name     = local.computed_job_name
  role_arn = aws_iam_role.sagemaker_execution.arn

  algorithm_specification {
    training_image     = var.training_image_uri
    training_input_mode = "File"
  }

  enable_network_isolation                   = true
  enable_inter_container_traffic_encryption  = true
  enable_managed_spot_training               = var.use_spot_instances

  hyperparameters = var.hyperparameters

  input_data_config {
    channel_name = "training"

    data_source {
      s3_data_source {
        s3_data_type              = "S3Prefix"
        s3_uri                    = var.s3_training_data_uri
        s3_data_distribution_type = "FullyReplicated"
      }
    }

    input_mode = "File"
  }

  output_data_config {
    s3_output_path = "s3://${aws_s3_bucket.artifacts.bucket}/${local.output_prefix}"
    kms_key_id     = var.kms_key_id != "" ? var.kms_key_id : null
  }

  resource_config {
    instance_count         = var.instance_count
    instance_type          = var.instance_type
    volume_size_in_gb      = var.volume_size_gb
  }

  stopping_condition {
    max_runtime_in_seconds = var.max_runtime_seconds
    max_wait_time_in_seconds = var.use_spot_instances ? var.max_wait_seconds : null
  }

  checkpoint_config {
    s3_uri     = "s3://${aws_s3_bucket.artifacts.bucket}/${local.checkpoint_prefix}"
    local_path = "/opt/ml/checkpoints"
  }

  vpc_config {
    security_group_ids = [aws_security_group.training.id]
    subnets            = var.private_subnet_ids
  }

  tags = {
    Name = local.computed_job_name
  }
}
