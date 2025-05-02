aws_region       = "us-east-1" # Production in a different region
environment      = "prod"
bucket_name_prefix = "terraform-demo"

common_tags = {
  ManagedBy   = "Terraform"
  Project     = "S3Deployment"
  Environment = "Production"
  Team        = "DevOps"
  CostCenter  = "12345"
}
