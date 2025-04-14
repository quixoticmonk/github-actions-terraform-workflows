aws_region       = "us-west-2"
environment      = "dev"
bucket_name_prefix = "terraform-demo"
sns_topic_arn    = ""
allowed_account_ids = ["123456789012"] # Development AWS account ID

common_tags = {
  ManagedBy   = "Terraform"
  Project     = "S3Deployment"
  Environment = "Development"
  Team        = "DevOps"
}
