# bootstrap/aws-oidc

The keyless foundation. Run this **once**, by hand, with an administrator's own
temporary AWS session — not a stored key.

```bash
cd bootstrap/aws-oidc
terraform init
terraform apply                 # creates the GitHub OIDC provider + deploy role
gh variable set AWS_ROLE_ARN \
  --org devsecops-playground-org \
  --body "$(terraform output -raw role_arn)"
```

After this, every `terraform-apply` run in the infra repo assumes the role via a
short-lived OIDC token. No AWS access key is stored anywhere.

If the account already has a GitHub OIDC provider, run with
`-var create_oidc_provider=false`.

This stack keeps its state locally by default; for a shared team, point it at the
same remote backend as the rest of infra once that exists.
