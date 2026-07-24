variable "dns_zone_id" {
  description = "Cloudflare zone id for this project's domain."
  type        = string
}

variable "deploy_public_key" {
  description = "Public half of the key CI deploys with. The private half is the VM_SSH_KEY secret."
  type        = string
  default     = ""
}

variable "ssh_key_fingerprints" {
  description = "DigitalOcean fingerprints of keys allowed to log in interactively."
  type        = list(string)
  default     = []
}

variable "ssh_allowed_cidrs" {
  description = "Who may reach port 22. Narrow this to your egress ranges."
  type        = list(string)
  default     = ["0.0.0.0/0", "::/0"]
}
