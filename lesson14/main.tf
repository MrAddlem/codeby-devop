terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.38.0"
    }
  }
}

provider "proxmox" {
  pm_api_url          = "https://192.168.15.15:8006/api2/json"
  pm_api_token_id     = "montero231@pve!montero231"
  pm_api_token_secret = "502f01d6-f8fc-4937-be31-dbb50f533b04"
  pm_tls_insecure     = true
}

resource "proxmox_virtual_environment_vm" "public_vm" {
  name        = "public-vm"
  description = "Public VM with Nginx"
  node_name   = "pve"
  vm_id       = 100

  network_device {
    bridge = "vmbr0"
  }

  operating_system {
    type = "l26"
  }

  disk {
    datastore_id = "Data"
    file_id      = "local:iso/debian-12.9.0-amd64-netinst.iso"
    interface    = "scsi0"
    size         = 20
  }

  initialization {
    ip_config {
      ipv4 {
        address = "192.168.15.115/24"
        gateway = "192.168.15.1"
      }
    }
    user_account {
      username = "admin"
      password = "admin"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "apt-get update",
      "apt-get install -y nginx",
      "systemctl enable nginx",
      "systemctl start nginx"
    ]

    connection {
      type     = "ssh"
      user     = "admin"
      password = "admin"
      host     = "192.168.15.115"
    }
  }
}

resource "proxmox_virtual_environment_vm" "private_vm" {
  name        = "private-vm"
  description = "Private VM with Nginx"
  node_name   = "pve"
  vm_id       = 101

  network_device {
    bridge = "vmbr1"
  }

  operating_system {
    type = "l26"
  }

  disk {
    datastore_id = "Data"
    file_id      = "local:iso/debian-12.9.0-amd64-netinst.iso"
    interface    = "scsi0"
    size         = 20
  }

  initialization {
    ip_config {
      ipv4 {
        address = "192.168.15.135/24"
        gateway = "192.168.15.1"
      }
    }
    user_account {
      username = "admin"
      password = "admin1"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "apt-get update",
      "apt-get install -y nginx",
      "sed -i 's/listen 80/listen 8080/g' /etc/nginx/sites-enabled/default",
      "systemctl enable nginx",
      "systemctl start nginx"
    ]

    connection {
      type     = "ssh"
      user     = "admin"
      password = "admin1"
      host     = "192.168.15.135"
    }
  }
}
