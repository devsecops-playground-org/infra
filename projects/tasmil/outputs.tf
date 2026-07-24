output "vm_hosts" {
  description = "environment => public IP. Copy into each tasmil repo's VM_HOST environment secret."
  value       = module.tasmil.vm_hosts
}

output "hostnames" {
  value = module.tasmil.hostnames
}
