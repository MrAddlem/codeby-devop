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