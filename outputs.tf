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

output "vpc_id" {
  description = "ID of the created VPC"
  value       = awscc_ec2_vpc.this.id
}

output "vpc_cidr_block" {
  description = "CIDR block of the created VPC"
  value       = awscc_ec2_vpc.this.cidr_block
}
