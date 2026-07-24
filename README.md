# infra

Every VM, DNS record and registry grant this organisation owns, as code.

One directory per project. Each one is a dozen lines calling the shared `project`
module in [`devsecops-playground-org/platform`](https://github.com/devsecops-playground-org/platform/tree/main/modules) —
the module holds the logic, this repo holds the declarations.

```
projects/
  arteamis/    frontend on Vercel + one EC2 VM per environment
  botanary/    frontend on Vercel + one EC2 VM per environment
  tasmil/      frontend on Vercel + one shared VM running backend, mcp and ai
```

## How a change ships

Open a pull request. The pipeline runs `fmt → validate → plan` and posts the plan
as a comment. Merge to `main` and the **same reviewed plan** is applied, after the
`production` environment's approval gate.

Nothing is applied from a laptop.

## Secrets

Cloud access is keyless: the pipeline assumes an IAM role via a short-lived
GitHub OIDC token. There is no stored AWS key. Run `bootstrap/aws-oidc` once to
create the provider and role, then set the `AWS_ROLE_ARN` variable.

Terraform variables that contain secrets are encrypted with SOPS + age and
committed as `secrets.enc.tfvars.json`. The private key lives only in the
`SOPS_AGE_KEY` repository secret.

| secret / variable | kind | purpose |
|---|---|---|
| `AWS_ROLE_ARN` | variable | keyless role the pipeline assumes (from bootstrap) |
| `CLOUDFLARE_API_TOKEN` | secret | DNS records |
| `SOPS_AGE_KEY` | secret | decrypting the tfvars above |
| `AWS_ROLE_ARN` | variable | OIDC role, when a stack uses AWS |

## After an apply

`terraform output vm_hosts` prints the addresses to copy into each application
repo's `VM_HOST` environment secret. That is the only handoff between this repo
and the application repos.
