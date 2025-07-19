terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = ">= 0.89.0" # Укажите актуальную версию
    }
  }
}

data "yandex_vpc_subnet" "subnets" {
  for_each = toset(data.yandex_vpc_network.selected.subnet_ids)
  subnet_id = each.key
}

data "yandex_vpc_network" "selected" {
  network_id = var.vpc_id
}
