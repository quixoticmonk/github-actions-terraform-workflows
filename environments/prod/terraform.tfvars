aws_region       = "us-east-1" # Production in a different region
environment      = "prod"
bucket_name_prefix = "terraform-demo"
sns_topic_arn    = "arn:aws:sns:us-east-1:345678901234:prod-notifications"
allowed_account_ids = ["345678901234"] # Production AWS account ID

common_tags = {
  ManagedBy   = "Terraform"
  Project     = "S3Deployment"
  Environment = "Production"
  Team        = "DevOps"
  CostCenter  = "12345"
}
