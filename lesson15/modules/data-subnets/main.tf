data "proxmox_virtual_environment_network_linux_bridges" "bridges" {
  node_name = var.node_name
}

data "proxmox_virtual_environment_network_linux_vlans" "vlans" {
  depends_on = [data.proxmox_virtual_environment_network_linux_bridges.bridges]
  node_name  = var.node_name
}

locals {
  subnets = flatten([
    for bridge in data.proxmox_virtual_environment_network_linux_bridges.bridges.linux_bridges : [
      for vlan in data.proxmox_virtual_environment_network_linux_vlans.vlans.linux_vlans : {
        name   = "${bridge.name}.${vlan.vlan}"
        bridge = bridge.name
        vlan   = vlan.vlan
        zone   = try(vlan.comments, "default")
      } if vlan.interface == bridge.name
    ]
  ])
}
