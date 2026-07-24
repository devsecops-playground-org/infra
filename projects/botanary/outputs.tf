output "vm_hosts" {
  description = "environment => public IP. Copy into each botanary repo's VM_HOST environment secret."
  value       = module.botanary.vm_hosts
}

output "hostnames" {
  value = module.botanary.hostnames
}
