terraform {
  required_providers {
    awscc = {
      source  = "hashicorp/awscc"
      version = "~> 1.0.0"
    }
  }
}

data "aws_caller_identity" "current" {}

provider "awscc" {
  region = var.aws_region
}

resource "awscc_s3_bucket" "this" {
  bucket_name = "${var.bucket_name_prefix}-${var.environment}-${var.aws_region}"

  tags = [{
    key   = "Modified By"
    value = "AWSCC"
  }]

}

# Add VPC resource using AWSCC provider
resource "awscc_ec2_vpc" "this" {
  cidr_block = var.vpc_cidr_block
  
  tags = [{
    key   = "Name"
    value = "${var.environment}-vpc"
  }, {
    key   = "Environment"
    value = var.environment
  }, {
    key   = "Modified By"
    value = "AWSCC"
  }]
}

# Optional bucket policy based on environment
resource "awscc_s3_bucket_policy" "this" {
  bucket = awscc_s3_bucket.this.id

  policy_document = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["s3:GetObject"]
        Effect   = "Allow"
        Resource = "${awscc_s3_bucket.this.arn}/*"
        Principal = {
          AWS = [data.aws_caller_identity.current.account_id]
        }
      }
    ]
  })
}
