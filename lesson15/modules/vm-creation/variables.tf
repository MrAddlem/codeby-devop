variable "subnets" {
  description = "Map of all subnets in the VPC"
  type = map(object({
    id          = string
    name        = string
    zone        = string
    v4_cidr     = list(string)
    route_table = string
  }))
}

variable "zone" {
  description = "Zone for VM creation"
  type        = string
}

variable "vm_name" {
  description = "Name of the virtual machine"
  type        = string
}

variable "vm_image_id" {
  description = "ID of the image to use for the VM"
  type        = string
}

variable "vm_user" {
  description = "Username for SSH access"
  type        = string
}

variable "vm_ssh_key_path" {
  description = "Path to the public SSH key"
  type        = string
}
