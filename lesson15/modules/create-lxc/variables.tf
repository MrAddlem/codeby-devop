variable "node_name" {
  type        = string
  description = "Name of the Proxmox node to create LXC on"
}

variable "vm_id" {
  type        = number
  description = "Unique ID for the LXC container"
}

variable "zone" {
  type        = string
  description = "Zone to select subnet from"
}

variable "ip_address" {
  type        = string
  description = "IP address for the container"
}

variable "cidr" {
  type        = number
  description = "Network CIDR (e.g., 24)"
  default     = 24
}

variable "gateway" {
  type        = string
  description = "Network gateway"
}

variable "description" {
  type        = string
  description = "Description for the container"
  default     = ""
}

variable "tags" {
  type        = list(string)
  description = "Tags for the container"
  default     = []
}

variable "template_id" {
  type        = string
  description = "ID of the template to use for the container"
}

variable "hostname" {
  type        = string
  description = "Hostname for the container"
}

variable "cpu_cores" {
  type        = number
  description = "Number of CPU cores"
  default     = 1
}

variable "memory" {
  type        = number
  description = "Memory in MB"
  default     = 1024
}

variable "storage" {
  type        = string
  description = "Storage name for root filesystem"
  default     = "local-lvm"
}

variable "disk_size" {
  type        = string
  description = "Root filesystem size (e.g., '8G')"
  default     = "8G"
}
