# Tasmil: three services — backend, mcp and ai — share one VM per environment.
# Each lands in /opt/tasmil/<component> and is rolled independently, so deploying
# the agent runner never restarts the API.

module "tasmil" {
  source = "git::https://github.com/devsecops-playground-org/platform.git//modules/project?ref=v1.0.0"

  project      = "tasmil"
  environments = ["staging", "production"]

  domain      = "tasmil.dev"
  dns_zone_id = var.dns_zone_id

  vm_components  = ["api", "mcp", "ai"]
  vercel_domains = ["tasmil.dev", "www.tasmil.dev", "staging.tasmil.dev"]

  vm = {
    region       = "sgp1"
    size         = "s-4vcpu-8gb" # three services on one box
    staging_size = "s-2vcpu-4gb"
  }

  deploy_public_key    = var.deploy_public_key
  ssh_key_fingerprints = var.ssh_key_fingerprints
  ssh_allowed_cidrs    = var.ssh_allowed_cidrs
}
