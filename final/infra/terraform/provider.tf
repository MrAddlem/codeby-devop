terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.77.0"
    }
  }
  backend "http" {}
}

provider "proxmox" {
  endpoint           = var.proxmox_endpoint
  username           = var.proxmox_username
  password           = var.proxmox_password
  insecure           = true
  random_vm_ids      = true
  random_vm_id_start = 1100
  random_vm_id_end   = 1400
}

variable "proxmox_endpoint" {
  type        = string
  description = "The endpoint for the Proxmox Virtual Environment API (example: https://host:port)"
}

variable "proxmox_username" {
  type        = string
  description = "The username and realm for the Proxmox Virtual Environment API (example: root@pam)"
}

variable "proxmox_password" {
  type        = string
  description = "The password for the Proxmox Virtual Environment API"
  sensitive   = true
}

