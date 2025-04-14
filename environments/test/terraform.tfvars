aws_region       = "us-west-2"
environment      = "test"
bucket_name_prefix = "terraform-demo"
sns_topic_arn    = "arn:aws:sns:us-west-2:123456789012:test-notifications"
allowed_account_ids = ["123456789012", "234567890123"] # Test and Dev AWS account IDs

common_tags = {
  ManagedBy   = "Terraform"
  Project     = "S3Deployment"
  Environment = "Test"
  Team        = "DevOps"
}
