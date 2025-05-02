aws_region       = "us-east-1"
environment      = "test"
bucket_name_prefix = "terraform-demo"

common_tags = {
  ManagedBy   = "Terraform"
  Project     = "S3Deployment"
  Environment = "Test"
  Team        = "DevOps"
}
