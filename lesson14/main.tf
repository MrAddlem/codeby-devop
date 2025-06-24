terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">=0.77.0"
    }
  }
}

provider "proxmox" {
  endpoint            = "https://10.38.16.18:8006/api2/json"
  username            = "secret@pam"
  password            = "secret_password"
  insecure            = true
}

resource "proxmox_virtual_environment_vm" "public_vm" {
  name        = "public-vm"
  description = "Public VM with Nginx"
  node_name   = "pve"
  vm_id       = 100

  network_device {
    bridge = "vmbr2"
    vlan_id = 23
  }

  operating_system {
    type = "l26"
  }

  disk {
    datastore_id = "Data"
    file_id      = "local:iso/debian-12.11.0-amd64-netinst.iso"
    interface    = "scsi0"
    size         = 20
  }

  initialization {
    ip_config {
      ipv4 {
        address = "10.38.23.135/24"
        gateway = "10.38.23.253"
      }
    }
    user_account {
      username = "root"
      password = "root"
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
      user     = "root"
      password = "root"
      host     = "10.38.23.135"
    }
  }
}

resource "proxmox_virtual_environment_vm" "private_vm" {
  name        = "private-vm"
  description = "Private VM with Nginx"
  node_name   = "ex10"
  vm_id       = 501

  network_device {
    bridge = "vmbr2"
    vlan_id = 21
  }

  operating_system {
    type = "l26"
  }

  disk {
    datastore_id = "Data"
    file_id      = "local:iso/debian-12.11.0-amd64-netinst.iso"
    interface    = "scsi0"
    size         = 20
  }

  initialization {
    ip_config {
      ipv4 {
        address = "10.38.21.135/24"
        gateway = "10.38.21.1"
      }
    }
    user_account {
      username = "root"
      password = "root1"
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
      user     = "root"
      password = "root1"
      host     = "10.38.21.135"
    }
  }
}
