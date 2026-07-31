# bootstrap/gcp-oidc

The keyless foundation for GCP — the twin of [`../aws-oidc`](../aws-oidc). Run this
**once**, by hand, with an administrator's own temporary `gcloud` session — not a
service-account JSON key.

```bash
gcloud auth application-default login          # admin's own session, no stored key
cd bootstrap/gcp-oidc
terraform init
terraform apply -var gcp_project_id=<your-gcp-project>   # WIF pool + deploy SA

gh variable set GCP_WORKLOAD_IDENTITY_PROVIDER \
  --org devsecops-playground-org \
  --body "$(terraform output -raw workload_identity_provider)"
gh variable set GCP_SERVICE_ACCOUNT \
  --org devsecops-playground-org \
  --body "$(terraform output -raw service_account_email)"
```

After this, every `terraform-apply` run for a `vm_cloud = "gcp"` project
authenticates by having GitHub mint a short-lived OIDC token that GCP exchanges
for a ~1h service-account credential. **No GCP key is stored anywhere.**

Prerequisite: enable the APIs the module and deploy touch, once per project:

```bash
gcloud services enable iamcredentials.googleapis.com sts.googleapis.com \
  compute.googleapis.com --project <your-gcp-project>
```

The terraform-apply workflow already reads these two variables (via
`actions/cloud-oidc-login`), so no workflow edit is needed — only set them:

- `GCP_WORKLOAD_IDENTITY_PROVIDER`
- `GCP_SERVICE_ACCOUNT`

This stack keeps its state locally by default; for a shared team, point it at the
same remote backend as the rest of infra once that exists.
