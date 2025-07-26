output "vm_name_and_ips" {
  value = {
    (var.name) = flatten([
      for ips in proxmox_virtual_environment_vm.vm.ipv4_addresses :
      [for ip in ips : ip if ip != "127.0.0.1"]
    ])
  }
}
