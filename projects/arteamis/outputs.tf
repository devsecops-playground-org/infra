output "vm_hosts" {
  description = "environment => public IP. Copy into each arteamis repo's VM_HOST environment secret."
  value       = module.arteamis.vm_hosts
}

output "hostnames" {
  value = module.arteamis.hostnames
}
