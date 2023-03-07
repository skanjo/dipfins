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

locals {
  lambda_name       = "dipfins-${var.stage}"
  lambda_build_path = "../target/dipfins-0.1.0-SNAPSHOT-standalone.jar"
  lambda_handler    = "dipfins.core.handler"
  s3_bucket_name    = "dipfins-store-${var.stage}"
}

data "aws_iam_policy_document" "lambda_s3_policy" {
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

resource aws_iam_policy lambda_s3_policy {
  name   = "dipfins-${var.stage}-s3"
  policy = data.aws_iam_policy_document.lambda_s3_policy.json
}

resource aws_iam_role_policy_attachment lambda_s3_policy {
  role       = module.lambda.lambda_role_name
  policy_arn = aws_iam_policy.lambda_s3_policy.arn
}

module "lambda" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-lambda.git?ref=v4.10.1"

  function_name = local.lambda_name
  description   = "Extract IPv4 addresses from S3 file and write result back to S3"
  handler       = local.lambda_handler
  runtime       = "java11"
  memory_size   = 512
  timeout       = 30

  create_package         = false
  local_existing_package = local.lambda_build_path
}

module "s3_bucket" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-s3-bucket?ref=v3.7.0"

  bucket = local.s3_bucket_name
  acl    = "private"

  versioning = {
    enabled = false
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
      filter_suffix = ".in.json"
    }
  }
}