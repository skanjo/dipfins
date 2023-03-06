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
}

module "lambda" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-lambda.git?ref=v4.10.1"

  function_name = local.lambda_name
  description   = "Extract IPv4 addresses from S3 file and write result back to S3"
  handler       = local.lambda_handler
  runtime       = "java11"
  memory_size   = 512

  create_package         = false
  local_existing_package = local.lambda_build_path
}
