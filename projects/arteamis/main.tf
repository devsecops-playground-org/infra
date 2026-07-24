# Arteamis: a Next.js frontend on Vercel and a FastAPI backend on its own VM.

module "arteamis" {
  source = "git::https://github.com/devsecops-playground-org/platform.git//modules/project?ref=v1.0.0"

  project      = "arteamis"
  environments = ["staging", "production"]

  domain      = "arteamis.dev"
  dns_zone_id = var.dns_zone_id

  vm_components  = ["api"]
  vercel_domains = ["arteamis.dev", "www.arteamis.dev", "staging.arteamis.dev"]

  vm = {
    region       = "sgp1"
    size         = "s-2vcpu-4gb"
    staging_size = "s-1vcpu-2gb"
  }

  deploy_public_key    = var.deploy_public_key
  ssh_key_fingerprints = var.ssh_key_fingerprints
  ssh_allowed_cidrs    = var.ssh_allowed_cidrs
}
