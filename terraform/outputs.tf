output "lambda_cloudwatch_log_group_arn" {
  description = "The ARN of the Cloudwatch Log Group"
  value       = try(module.lambda.lambda_cloudwatch_log_group_arn, "")
}

output "lambda_cloudwatch_log_group_name" {
  description = "The name of the Cloudwatch Log Group"
  value       = try(module.lambda.lambda_cloudwatch_log_group_name, "")
}

output "lambda_function_arn" {
  description = "The ARN of the Lambda Function"
  value       = try(module.lambda.lambda_function_arn, "")
}
output "lambda_function_name" {
  description = "The name of the Lambda Function"
  value       = try(module.lambda.lambda_function_name, "")
}

output "lambda_role_arn" {
  description = "The ARN of the IAM role created for the Lambda Function"
  value       = try(module.lambda.lambda_role_arn, "")
}

output "lambda_role_name" {
  description = "The name of the IAM role created for the Lambda Function"
  value       = try(module.lambda.lambda_role_name, "")
}

output "s3_bucket_arn" {
  description = "The ARN of the bucket. Will be of format arn:aws:s3:::bucketname."
  value       = try(module.s3_bucket.s3_bucket_arn, "")
}

output "s3_bucket_bucket_domain_name" {
  description = "The bucket domain name. Will be of format bucketname.s3.amazonaws.com."
  value       = try(module.s3_bucket.s3_bucket_bucket_domain_name, "")
}