<!-- BEGIN_TF_DOCS -->
# Terraform S3 Bucket Deployment with GitHub Actions

This repository contains Terraform configurations to deploy S3 buckets across multiple environments (dev, test, prod) using GitHub Actions workflows.

## Project Structure

```
.
├── .github
│   └── workflows
│       ├── terraform-reusable.yml    # Reusable workflow template
│       ├── pr-workflow.yml           # Pull request workflow
│       ├── scenario1-workflow.yml    # Main to dev, manual for test/prod
│       ├── scenario2-dev.yml         # Dev branch to dev environment
│       ├── scenario2-test.yml        # Test branch to test environment
│       └── scenario2-prod.yml        # Main branch to prod environment
├── environments
│   ├── dev
│   │   └── terraform.tfvars
│   ├── test
│   │   └── terraform.tfvars
│   └── prod
│       └── terraform.tfvars
├── backend.tf                        # S3 backend configuration
├── main.tf                           # Main Terraform configuration
├── variables.tf                      # Variable definitions
├── outputs.tf                        # Output definitions
└── README.md
```

## Features

- Uses AWSCC provider (version 1.0.0+) for AWS resource provisioning
- Environment-specific configurations (dev, test, prod)
- Reusable GitHub Actions workflow for consistent deployments
- Multiple workflow options for different branching strategies
- S3 backend with built-in state locking
- Region-specific bucket naming for uniqueness

## Workflow Options & Branching Strategies

This repository provides two different workflow strategies to accommodate different team preferences:

### Scenario 1: Main Branch with Manual Promotion

```
Scenario 1: Main Branch with Manual Promotion
---------------------------------------------

  Developer Push     GitHub Actions       Environments
       |                  |                    |
       |                  |                    |
       |                  |                    |
       v                  v                    v
  [Push to main] --> [Auto Deploy] -------> [DEV]
                         |
                         |
                    [Manual Trigger]
                         |
                        / \
                       /   \
                      v     v
                   [TEST]  [PROD]
```

- **Development**: Automatically deployed on pushes to the `main` branch
- **Test/Production**: Manually triggered via workflow dispatch
- **Ideal for**: Teams that prefer a single main branch with manual promotion to higher environments

### Scenario 2: Environment-Specific Branches

```
Scenario 2: Environment-Specific Branches
---------------------------------------------

  Developer Push     GitHub Actions       Environments
       |                  |                    |
       |                  |                    |
       |                  |                    |
       |--[Push to dev/*]-|--[Auto Deploy]-->[DEV]
       |                  |                    |
       |--[Push to test/*]|--[Auto Deploy]-->[TEST]
       |                  |                    |
       |--[Push to main]--|--[Auto Deploy]-->[PROD]
```

- **Development**: Automatically deployed on pushes to `dev/*` branches
- **Test**: Automatically deployed on pushes to `test/*` branches
- **Production**: Automatically deployed on pushes to the `main` branch
- **Ideal for**: Teams that prefer separate branches for each environment

### Pull Request Workflow

```
Pull Request Workflow
---------------------------------------------

  Developer          GitHub Actions         PR Comments
       |                  |                      |
       |                  |                      |
       |                  |                      |
  [Create PR] -------> [Checkov] --------> [Security Results]
       |                  |                      |
       |                  |                      |
       |              [Terraform Test] ---> [Test Results]
       |                  |                      |
       |                  |                      |
       |              [Terraform Plan] ---> [Plan Results]
       |                  |                      |
       v                  v                      v
  [Review PR] <----------------------------------|
```

All pull requests trigger:
- Checkov security scans
- Terraform tests (if available)
- Terraform plan generation with results posted as PR comments
- The target environment is determined based on the target branch of the PR

## Prerequisites

1. AWS account with appropriate permissions
2. GitHub repository secrets:
   - `AWS_ROLE_TO_ASSUME`: Default IAM role ARN for GitHub Actions
   - `AWS_ROLE_TO_ASSUME_DEV`: IAM role ARN for dev environment (Scenario 2)
   - `AWS_ROLE_TO_ASSUME_TEST`: IAM role ARN for test environment (Scenario 2)
   - `AWS_ROLE_TO_ASSUME_PROD`: IAM role ARN for prod environment (Scenario 2)
   - `AWS_REGION`: Default AWS region
   - `S3_BUCKET_NAME`: S3 bucket for Terraform state (region will be appended)
   - `S3_KEY_PREFIX`: Key prefix for Terraform state files

## Usage

### Scenario 1: Main Branch with Manual Promotion

1. Push to `main` branch to automatically deploy to dev environment
2. To deploy to test or prod:
   - Go to the "Actions" tab in your GitHub repository
   - Select the "Scenario 1 - Main to Dev, Manual for Test/Prod" workflow
   - Click "Run workflow"
   - Select the target environment (test or prod)
   - Click "Run workflow"

### Scenario 2: Environment-Specific Branches

1. Push to a `dev/*` branch to automatically deploy to dev environment
2. Push to a `test/*` branch to automatically deploy to test environment
3. Push to the `main` branch to automatically deploy to prod environment

### Pull Requests

1. Create a PR to any branch
2. The workflow will automatically run security scans and generate a Terraform plan
3. Review the plan in the PR comments before merging

## Customization

Modify the `terraform.tfvars` files in each environment directory to customize the deployment for each environment.

## Security Considerations

- The workflow uses OIDC to authenticate with AWS, avoiding long-lived credentials
- Environment-specific IAM roles should be used for different environments
- Sensitive variables should be stored as GitHub secrets
- Checkov security scans help identify potential security issues in your Terraform code

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_awscc"></a> [awscc](#requirement\_awscc) | ~> 1.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_awscc"></a> [awscc](#provider\_awscc) | ~> 1.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [awscc_s3_bucket.that](https://registry.terraform.io/providers/hashicorp/awscc/latest/docs/resources/s3_bucket) | resource |
| [awscc_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/awscc/latest/docs/resources/s3_bucket) | resource |
| [awscc_s3_bucket_policy.this](https://registry.terraform.io/providers/hashicorp/awscc/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_account_ids"></a> [allowed\_account\_ids](#input\_allowed\_account\_ids) | List of AWS account IDs allowed to access the bucket | `list(string)` | `[]` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region to deploy resources | `string` | `"us-east-1"` | no |
| <a name="input_bucket_name_prefix"></a> [bucket\_name\_prefix](#input\_bucket\_name\_prefix) | Prefix for the S3 bucket name | `string` | `"terraform-demo"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name (dev, test, prod) | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_arn"></a> [bucket\_arn](#output\_bucket\_arn) | ARN of the created S3 bucket |
| <a name="output_bucket_name"></a> [bucket\_name](#output\_bucket\_name) | Name of the created S3 bucket |
| <a name="output_bucket_region"></a> [bucket\_region](#output\_bucket\_region) | Region of the created S3 bucket |
| <a name="output_environment"></a> [environment](#output\_environment) | Deployment environment |
<!-- END_TF_DOCS -->
