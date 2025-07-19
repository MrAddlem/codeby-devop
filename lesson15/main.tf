terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = ">= 0.89.0" # Укажите актуальную версию
    }
  }
}

provider "yandex" {
  token     = var.yc_token
  cloud_id  = var.yc_cloud_id
  folder_id = var.yc_folder_id
  zone      = var.yc_zone
}

module "subnets_data" {
  source    = "./modules/data-subnets"
  vpc_id    = var.vpc_id
}

module "vm_creation" {
  source          = "./modules/vm-creation"
  subnets         = module.subnets_data.subnets
  zone            = var.yc_zone
  vm_name         = var.vm_name
  vm_image_id     = var.vm_image_id
  vm_user         = var.vm_user
  vm_ssh_key_path = var.vm_ssh_key_path
}
