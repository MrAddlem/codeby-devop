terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.89.0"
    }
  }
}

locals {
  # Find subnet in the specified zone
  target_subnet = [
    for id, subnet in var.subnets :
    subnet if subnet.zone == var.zone
  ][0]
}

data "yandex_compute_image" "ubuntu" {
  family    = "ubuntu-2204-lts"
  folder_id = "standard-images"
}

resource "yandex_compute_instance" "vm" {
  name        = var.vm_name
  platform_id = "standard-v1"
  zone        = var.zone

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = 20
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id = local.target_subnet.id
    nat       = true
  }

  metadata = {
    ssh-keys = "${var.vm_user}:${file(var.vm_ssh_key_path)}"
  }
}
