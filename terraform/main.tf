terraform {
  required_version = ">= 0.14.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.44"
    }
  }
}
provider "aws" {
  region = "us-east-1"
}

data "aws_iam_policy_document" "lambda_s3" {
  version = "2012-10-17"
  statement {
    sid     = "AllowLambdaS3Access"
    effect  = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject"
    ]
    resources = [
      "${module.s3_bucket.s3_bucket_arn}/*"
    ]
  }
}

resource aws_iam_policy lambda_s3 {
  name   = "${var.service_name}-s3"
  policy = data.aws_iam_policy_document.lambda_s3.json
}

resource aws_iam_role_policy_attachment lambda_s3 {
  role       = module.lambda.lambda_role_name
  policy_arn = aws_iam_policy.lambda_s3.arn
}

module "lambda" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-lambda.git?ref=v4.10.1"

  function_name = var.service_name
  description   = "Extract IPv4 addresses from S3 file and write result back to S3"
  handler       = var.lambda_handler
  runtime       = var.lambda_runtime
  memory_size   = var.lambda_memory_size
  timeout       = var.lambda_timeout

  create_package         = false
  local_existing_package = var.lambda_build_path
}

module "s3_bucket" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-s3-bucket?ref=v3.7.0"

  bucket        = var.service_name
  acl           = "private"
  force_destroy = var.s3_force_destroy

  versioning = {
    enabled = var.s3_versioning_enabled
  }
}

module "s3_bucket_notification" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-s3-bucket.git//modules/notification?ref=v3.7.0"

  bucket = module.s3_bucket.s3_bucket_id

  lambda_notifications = {
    lambda = {
      function_arn  = module.lambda.lambda_function_arn
      function_name = module.lambda.lambda_function_name
      events        = ["s3:ObjectCreated:*"]
      filter_suffix = var.s3_filter_suffix
    }
  }
}