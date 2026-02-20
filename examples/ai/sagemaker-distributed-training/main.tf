data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

locals {
  training_data_path  = replace(var.s3_training_data_uri, "s3://", "")
  training_data_parts = split("/", local.training_data_path)
  training_bucket     = local.training_data_parts[0]
  training_prefix     = length(local.training_data_parts) > 1 ? join("/", slice(local.training_data_parts, 1, length(local.training_data_parts))) : ""

  output_bucket_name     = var.model_artifact_bucket_name != "" ? var.model_artifact_bucket_name : "${var.name_prefix}-${data.aws_caller_identity.current.account_id}-${var.region}-artifacts"
  output_prefix          = "output"
  checkpoint_prefix      = "checkpoints"
  computed_pipeline_name = var.pipeline_name != "" ? var.pipeline_name : "${var.name_prefix}-${var.environment}"

  training_output_data_config = merge(
    {
      S3OutputPath = "s3://${aws_s3_bucket.artifacts.bucket}/${local.output_prefix}"
    },
    var.kms_key_id != "" ? { KmsKeyId = var.kms_key_id } : {}
  )

  training_stopping_condition = merge(
    {
      MaxRuntimeInSeconds = var.max_runtime_seconds
    },
    var.use_spot_instances ? { MaxWaitTimeInSeconds = var.max_wait_seconds } : {}
  )

  training_step_arguments = {
    AlgorithmSpecification = {
      TrainingImage     = var.training_image_uri
      TrainingInputMode = "File"
    }
    HyperParameters = var.hyperparameters
    InputDataConfig = [
      {
        ChannelName = "training"
        DataSource = {
          S3DataSource = {
            S3DataType             = "S3Prefix"
            S3Uri                  = { Get = "Parameters.InputDataS3Uri" }
            S3DataDistributionType = "FullyReplicated"
          }
        }
        InputMode = "File"
      }
    ]
    OutputDataConfig = local.training_output_data_config
    ResourceConfig = {
      InstanceCount  = { Get = "Parameters.InstanceCount" }
      InstanceType   = { Get = "Parameters.InstanceType" }
      VolumeSizeInGB = var.volume_size_gb
    }
    StoppingCondition         = local.training_stopping_condition
    EnableManagedSpotTraining = var.use_spot_instances
    CheckpointConfig = {
      S3Uri     = "s3://${aws_s3_bucket.artifacts.bucket}/${local.checkpoint_prefix}"
      LocalPath = "/opt/ml/checkpoints"
    }
    VpcConfig = {
      SecurityGroupIds = [aws_security_group.training.id]
      Subnets          = var.private_subnet_ids
    }
    RoleArn = aws_iam_role.sagemaker_execution.arn
  }

  pipeline_definition = jsonencode({
    Version = "2020-12-01"
    Parameters = [
      {
        Name         = "InputDataS3Uri"
        Type         = "String"
        DefaultValue = var.s3_training_data_uri
      },
      {
        Name         = "InstanceType"
        Type         = "String"
        DefaultValue = var.instance_type
      },
      {
        Name         = "InstanceCount"
        Type         = "Integer"
        DefaultValue = var.instance_count
      }
    ]
    Steps = [
      {
        Name      = "DistributedTrainingStep"
        Type      = "Training"
        Arguments = local.training_step_arguments
      }
    ]
  })
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

resource "aws_sagemaker_pipeline" "distributed_training" {
  pipeline_name         = local.computed_pipeline_name
  role_arn              = aws_iam_role.sagemaker_execution.arn
  pipeline_display_name = local.computed_pipeline_name
  pipeline_description  = "Distributed GPU training pipeline managed by Terraform."
  pipeline_definition   = local.pipeline_definition

  tags = {
    Name = local.computed_pipeline_name
  }
}
