# infra

Every VM, DNS record and registry grant this organisation owns, as code.

One directory per project. Each one is a dozen lines calling the shared `project`
module in [`devsecops-playground-org/platform`](https://github.com/devsecops-playground-org/platform/tree/main/modules) —
the module holds the logic, this repo holds the declarations.

```
projects/
  arteamis/    frontend on Vercel + one API VM per environment
  botanary/    frontend on Vercel + one API VM per environment
  tasmil/      frontend on Vercel + one shared VM running backend, mcp and ai
```

## How a change ships

Open a pull request. The pipeline runs `fmt → validate → plan` and posts the plan
as a comment. Merge to `main` and the **same reviewed plan** is applied, after the
`production` environment's approval gate.

Nothing is applied from a laptop.

## Secrets

Cloud access is keyless via OIDC wherever the provider supports it. DigitalOcean
does not, so its token is an environment secret and is rotated on a schedule.

Terraform variables that contain secrets are encrypted with SOPS + age and
committed as `secrets.enc.tfvars.json`. The private key lives only in the
`SOPS_AGE_KEY` repository secret.

| secret / variable | kind | purpose |
|---|---|---|
| `DIGITALOCEAN_ACCESS_TOKEN` | secret | droplets and firewalls |
| `CLOUDFLARE_API_TOKEN` | secret | DNS records |
| `SOPS_AGE_KEY` | secret | decrypting the tfvars above |
| `AWS_ROLE_ARN` | variable | OIDC role, when a stack uses AWS |

## After an apply

`terraform output vm_hosts` prints the addresses to copy into each application
repo's `VM_HOST` environment secret. That is the only handoff between this repo
and the application repos.
