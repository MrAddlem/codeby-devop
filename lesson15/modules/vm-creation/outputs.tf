output "vm_external_ip" {
  description = "External IP address of the created VM"
  value       = yandex_compute_instance.vm.network_interface.0.nat_ip_address
}

output "vm_internal_ip" {
  description = "Internal IP address of the created VM"
  value       = yandex_compute_instance.vm.network_interface.0.ip_address
}
