# One-time bootstrap: the GitHub->AWS OIDC provider and the IAM role the pipeline
# assumes. Apply this ONCE, with an administrator's own AWS session (SSO / a
# short-lived admin role) — never with a long-lived key, and never with a key
# pasted into a chat. Its output becomes the AWS_ROLE_ARN variable.
#
#   cd bootstrap/aws-oidc
#   terraform init && terraform apply
#   gh variable set AWS_ROLE_ARN --org devsecops-playground-org --body "$(terraform output -raw role_arn)"

terraform {
  required_version = ">= 1.9"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.60"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  type    = string
  default = "ap-southeast-1"
}

variable "create_oidc_provider" {
  description = "Set false if this AWS account already has a GitHub OIDC provider."
  type        = bool
  default     = true
}

module "oidc" {
  source = "git::https://github.com/devsecops-playground-org/platform.git//modules/aws-oidc?ref=v1.0.0"

  org                  = "devsecops-playground-org"
  role_name            = "github-actions-deploy"
  create_oidc_provider = var.create_oidc_provider

  # infra applies the Terraform; app repos SSH to the VM and need no AWS access.
  allowed_subjects = ["repo:devsecops-playground-org/infra:*"]
}

output "role_arn" {
  description = "Set as the AWS_ROLE_ARN org/repo variable so terraform-apply can assume it."
  value       = module.oidc.role_arn
}

output "oidc_provider_arn" {
  value = module.oidc.oidc_provider_arn
}
