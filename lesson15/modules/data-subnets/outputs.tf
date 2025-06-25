output "subnets" {
  value       = local.subnets
  description = "List of all subnets with their attributes"
}

output "subnets_by_zone" {
  value = {
    for subnet in local.subnets :
    subnet.zone => subnet...
  }
  description = "Subnets grouped by zone"
}
