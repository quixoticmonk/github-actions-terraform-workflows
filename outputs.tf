output "bucket_name" {
  description = "Name of the created S3 bucket"
  value       = awscc_s3_bucket.this.bucket_name
}

output "bucket_arn" {
  description = "ARN of the created S3 bucket"
  value       = awscc_s3_bucket.this.arn
}

output "bucket_region" {
  description = "Region of the created S3 bucket"
  value       = var.aws_region
}

output "environment" {
  description = "Deployment environment"
  value       = var.environment
}
