variable "yc_token" {
  description = "Yandex Cloud OAuth token"
  type        = string
  sensitive   = true
}

variable "yc_cloud_id" {
  description = "Yandex Cloud ID"
  type        = string
  sensitive   = true
}

variable "yc_folder_id" {
  description = "Yandex Cloud Folder ID"
  type        = string
  sensitive   = true
}

variable "yc_zone" {
  description = "Yandex Cloud default zone"
  type        = string
  default     = "ru-central1-a"
}

variable "vpc_id" {
  description = "ID of the VPC network"
  type        = string
}

variable "vm_name" {
  description = "Name of the virtual machine"
  type        = string
  default     = "terraform-vm"
}

variable "vm_image_id" {
  description = "ID of the image to use for the VM"
  type        = string
  default     = "fd87va5cc00gaq2f5qfb" # Ubuntu 20.04
}

variable "vm_user" {
  description = "Username for SSH access"
  type        = string
  default     = "ubuntu"
}

variable "vm_ssh_key_path" {
  description = "Path to the public SSH key"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}
