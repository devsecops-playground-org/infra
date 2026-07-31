# One-time bootstrap: the GitHub->GCP Workload Identity Federation pool and the
# deploy service account the pipeline impersonates. Apply this ONCE, with an
# administrator's own gcloud session (Application Default Credentials) — never
# with a service-account JSON key, and never with a key pasted into a chat.
# Its outputs become the GCP_WORKLOAD_IDENTITY_PROVIDER and GCP_SERVICE_ACCOUNT
# variables that actions/cloud-oidc-login already reads.
#
#   gcloud auth application-default login          # admin's own session
#   cd bootstrap/gcp-oidc
#   terraform init && terraform apply -var gcp_project_id=<your-gcp-project>
#   gh variable set GCP_WORKLOAD_IDENTITY_PROVIDER --org devsecops-playground-org \
#     --body "$(terraform output -raw workload_identity_provider)"
#   gh variable set GCP_SERVICE_ACCOUNT --org devsecops-playground-org \
#     --body "$(terraform output -raw service_account_email)"

terraform {
  required_version = ">= 1.9"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
}

provider "google" {
  project = var.gcp_project_id
}

variable "gcp_project_id" {
  description = "GCP project id to create the pool and deploy SA in."
  type        = string
}

module "oidc" {
  source = "git::https://github.com/devsecops-playground-org/platform.git//modules/gcp-oidc?ref=v1.0.0"

  gcp_project_id = var.gcp_project_id
  org            = "devsecops-playground-org"

  # infra applies the Terraform; app repos SSH to the VM and need no GCP access.
  allowed_repositories = ["devsecops-playground-org/infra"]
}

output "workload_identity_provider" {
  description = "Set as the GCP_WIF_PROVIDER org/repo variable so terraform-apply can authenticate."
  value       = module.oidc.workload_identity_provider
}

output "service_account_email" {
  description = "Set as the GCP_DEPLOY_SA org/repo variable."
  value       = module.oidc.service_account_email
}
