output "vm_external_ip" {
  description = "External IP address of the created VM"
  value       = module.vm_creation.vm_external_ip
}

output "vm_internal_ip" {
  description = "Internal IP address of the created VM"
  value       = module.vm_creation.vm_internal_ip
}

output "subnets_info" {
  description = "Information about all subnets in the VPC"
  value       = module.subnets_data.subnets
}
