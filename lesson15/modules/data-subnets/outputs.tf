output "subnets" {
  description = "Information about all subnets in the VPC"
  value = {
    for subnet in data.yandex_vpc_subnet.subnets :
    subnet.id => {
      id          = subnet.id
      name        = subnet.name
      zone        = subnet.zone
      v4_cidr     = subnet.v4_cidr_blocks
      route_table = subnet.route_table_id
    }
  }
}
