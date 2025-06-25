terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.78.0"
    }
  }
}

module "subnets" {
  source    = "../data-subnets"
  node_name = var.node_name
}

resource "proxmox_virtual_environment_container" "lxc" {
  node_name = var.node_name
  vm_id     = var.vm_id

  description = var.description
  tags        = var.tags

  operating_system {
    template_file_id = var.template_id
    type             = "unmanaged"
  }

  initialization {
    hostname = var.hostname
  }

  cpu {
    cores = var.cpu_cores
  }

  memory {
    dedicated = var.memory
  }

  network_interface {
    name    = "eth0"
    bridge  = local.selected_subnet.bridge
    tag     = local.selected_subnet.vlan
    ipv4 {
      address = "${var.ip_address}/${var.cidr}"
      gateway = var.gateway
    }
  }

  rootfs {
    storage = var.storage
    size    = var.disk_size
  }
}

locals {
  selected_subnet = try(
    module.subnets.subnets_by_zone[var.zone][0],
    module.subnets.subnets[0]
  )
}
