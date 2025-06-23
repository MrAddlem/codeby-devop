# lesson14/firewall.tf
resource "proxmox_virtual_environment_firewall_rules" "public_rules" {
  node_name = "pve"
  vm_id     = proxmox_virtual_environment_vm.public_vm.vm_id

  rule {
    type    = "in"
    action  = "ACCEPT"
    comment = "Allow SSH"
    dport   = "22"
    proto   = "tcp"
  }

  rule {
    type    = "in"
    action  = "ACCEPT"
    comment = "Allow HTTP"
    dport   = "80"
    proto   = "tcp"
  }

  rule {
    type    = "in"
    action  = "ACCEPT"
    comment = "Allow HTTPS"
    dport   = "443"
    proto   = "tcp"
  }
}

resource "proxmox_virtual_environment_firewall_rules" "private_rules" {
  node_name = "pve"
  vm_id     = proxmox_virtual_environment_vm.private_vm.vm_id

  rule {
    type    = "in"
    action  = "ACCEPT"
    comment = "Allow SSH"
    dport   = "22"
    proto   = "tcp"
  }

  rule {
    type    = "in"
    action  = "ACCEPT"
    comment = "Allow custom port"
    dport   = "8080"
    proto   = "tcp"
  }
}
