aws_region       = "us-east-1"
environment      = "dev"
bucket_name_prefix = "terraform-demo"
sns_topic_arn    = ""

common_tags = {
  ManagedBy   = "Terraform"
  Project     = "S3Deployment"
  Environment = "Development"
  Team        = "DevOps"
}
