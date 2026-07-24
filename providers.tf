terraform {
  required_version = ">= 1.9"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.60"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  # Credentials come from the GitHub OIDC role at runtime (keyless); locally,
  # from your normal AWS profile. Never a static key in this repo.
}

provider "cloudflare" {
  # CLOUDFLARE_API_TOKEN is injected from the secrets manager / CI secret.
}

variable "aws_region" {
  type    = string
  default = "ap-southeast-1"
}
