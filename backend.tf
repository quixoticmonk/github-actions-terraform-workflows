terraform {
  backend "s3" {
    # These values will be filled by the CI/CD pipeline
    # bucket = "terraform-state-${var.aws_region}"
    # key    = "terraform.tfstate"
    # region = var.aws_region
  }
}
