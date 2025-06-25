output "lxc_id" {
  value       = proxmox_virtual_environment_container.lxc.vm_id
  description = "ID of the created LXC container"
}

output "ip_address" {
  value       = var.ip_address
  description = "IP address of the created LXC container"
}
