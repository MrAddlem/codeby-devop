terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.78.0"
    }
  }
}

provider "proxmox" {
  # Configuration options
  endpoint = var.proxmox_api_url
  username = var.proxmox_username
  password = var.proxmox_password
  insecure = var.proxmox_insecure
}

module "lxc" {
  source     = "./modules/create-lxc"
  node_name  = var.lxc_node_name
  vm_id      = var.lxc_vm_id
  zone       = var.lxc_zone
  ip_address = var.lxc_ip_address
  gateway    = var.lxc_gateway
  template_id = var.template_id
  hostname   = var.hostname
}
