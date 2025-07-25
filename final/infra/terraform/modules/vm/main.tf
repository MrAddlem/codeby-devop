terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.77.0"
    }
  }
}

resource "proxmox_virtual_environment_vm" "vm" {
  name          = var.name
  node_name     = var.node
  description   = "Managed by Terraform"
  tags          = ["terraform", "rocky"]
  scsi_hardware = "virtio-scsi-pci"
  bios          = "ovmf"
  protection    = var.protection
  migrate       = true

  clone {
    vm_id        = 1220
    node_name    = "ex10"
    full         = true
  }

  agent {
    enabled = true
  }

  cpu {
    cores = var.cpu_cores
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = var.memory_mb
  }

  disk {
    datastore_id = var.disk_datastore
    size         = var.disk_size_gb
    interface    = "scsi0"
    file_format  = "raw"
  }

  efi_disk {
     datastore_id      = var.disk_datastore
     file_format       = "raw"
     type              = "4m"
     pre_enrolled_keys = true
   }

  dynamic "network_device" {
    for_each = var.network_devices
    content {
      bridge  = network_device.value.bridge
      vlan_id = network_device.value.vlan_id
      mac_address = network_device.value.mac_address
    }
  }

  dynamic "initialization" {
    for_each = var.ipv4_address == "DHCP" ? [] : [1]
    content {
      datastore_id = var.disk_datastore
      dns {
        servers = var.dns_servers
        domain = "localdomain"
      }
      ip_config {
        ipv4 {
          address = var.ipv4_address
          gateway = var.ipv4_gateway
        }
      }
    }
  }

}
