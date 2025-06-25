variable "proxmox_api_url" {
  type        = string
  description = "URL of the Proxmox API"
}

variable "proxmox_username" {
  type        = string
  description = "Username for Proxmox API authentication"
}

variable "proxmox_password" {
  type        = string
  description = "Password for Proxmox API authentication"
  sensitive   = true
}

variable "proxmox_insecure" {
  type        = bool
  description = "Whether to skip TLS verification"
  default     = false
}

variable "template_id" {
  type        = string
  description = "ID of the LXC template to use"
}

variable "hostname" {
  type        = string
  description = "Hostname for the LXC container"
}

variable "lxc_node_name" {
  type        = string
  description = "Proxmox node name where LXC will be created"
}

variable "lxc_vm_id" {
  type        = number
  description = "Unique ID for the LXC container"
}

variable "lxc_zone" {
  type        = string
  description = "Zone for network selection"
}

variable "lxc_ip_address" {
  type        = string
  description = "IP address for the container"
}

variable "lxc_gateway" {
  type        = string
  description = "Network gateway for the container"
}

variable "lxc_one" {
  description = "Description for lxc_one variable"
  type        = string # укажите правильный тип (string, number, bool и т.д.)
}

variable "mplate_id" {
  description = "Description for mplate_id variable"
  type        = string # укажите правильный тип
}
