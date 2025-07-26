variable "name" {
  type        = string
  description = "Name of the virtual machine"
}

variable "node" {
  type        = string
  description = "Proxmox node on which the VM will be created"
}

variable "cpu_cores" {
  type        = number
  description = "Number of CPU cores allocated to the VM"
}

variable "memory_mb" {
  type        = number
  description = "Amount of RAM in megabytes allocated to the VM"
}

variable "disk_size_gb" {
  type        = number
  description = "Size of the primary disk in gigabytes"
}

variable "disk_datastore" {
  type        = string
  description = "Name of the datastore to use for the VM's disk"
}

variable "network_devices" {
  type = list(object({
    bridge      = string
    vlan_id     = number
    mac_address = optional(string)
  }))
  default = [
    { bridge = "vmbr2", vlan_id = 26 }
  ]
  description = <<-EOT
    List of network interfaces. Each item should include:
    - bridge: name of the Proxmox bridge interface (e.g., vmbr0)
    - vlan_id: VLAN tag for the interface (e.g., 10)
    - mac_address: (Optional) The MAC address (e.g., 00:0c:29:7d:f2:d7)
  EOT
}

variable "ipv4_address" {
  type        = string
  description = "IPv4 address for the VM (e.g., '192.168.1.10/24' or 'DHCP')"
}

variable "ipv4_gateway" {
  type        = string
  default     = "10.38.26.1"
  description = "Optional IPv4 gateway for the VM (only used with static IP)"
}

variable "dns_servers" {
  type        = list(string)
  default     = ["10.38.22.4"]
  description = "Optional list of DNS servers for the VM"
}

variable "protection" {
  type        = bool
  default     = false
  description = <<-EOT
    Sets the protection flag of the VM.
    This will disable the remove VM and remove disk operations (defaults to false).
  EOT
}
