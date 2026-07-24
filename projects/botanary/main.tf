# Botanary: a Vite frontend on Vercel and a Go backend on its own VM.
# The contracts repository has no infrastructure — it deploys to a chain, by hand.

module "botanary" {
  source = "git::https://github.com/devsecops-playground-org/platform.git//modules/project?ref=v1.0.0"

  project      = "botanary"
  environments = ["staging", "production"]

  domain      = "botanary.dev"
  dns_zone_id = var.dns_zone_id

  vm_components  = ["api"]
  vercel_domains = ["botanary.dev", "www.botanary.dev", "staging.botanary.dev"]

  vm = {
    size         = "t3.small"
    staging_size = "t3.micro"
  }

  deploy_public_key = var.deploy_public_key
  ssh_allowed_cidrs = var.ssh_allowed_cidrs
}
