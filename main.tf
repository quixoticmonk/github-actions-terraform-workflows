terraform {
  required_providers {
    awscc = {
      source  = "hashicorp/awscc"
      version = "~> 1.0.0"
    }
  }
}

provider "awscc" {
  region = var.aws_region
}

resource "awscc_s3_bucket" "this" {
  bucket_name = "${var.bucket_name_prefix}-${var.environment}-${var.aws_region}"
  
  tags = merge(
    var.common_tags,
    {
      Environment = var.environment
    }
  )
}

# Optional bucket policy based on environment
resource "awscc_s3_bucket_policy" "this" {
  bucket = awscc_s3_bucket.this.id
  
  policy_document = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = ["s3:GetObject"]
        Effect = "Allow"
        Resource = "${awscc_s3_bucket.this.arn}/*"
        Principal = {
          AWS = var.allowed_account_ids
        }
      }
    ]
  })
}
