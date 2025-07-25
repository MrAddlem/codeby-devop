module "ksb-prod-app" {
  source         = "./modules/vm"
  name           = "ksb-prod-app"
  node           = "ex10"
  cpu_cores      = 4
  memory_mb      = 8192
  disk_size_gb   = 100
  disk_datastore = "SAS_storage"
  ipv4_address   = "10.38.26.101/24"
}

module "ksb-prod-db" {
  source         = "./modules/vm"
  name           = "ksb-prod-db"
  node           = "ex10"
  cpu_cores      = 4
  memory_mb      = 8192
  disk_size_gb   = 100
  disk_datastore = "SAS_storage"
  ipv4_address   = "10.38.26.102/24"
}

module "ksb-prod-rmq" {
  source         = "./modules/vm"
  name           = "ksb-prod-rmq"
  node           = "ex10"
  cpu_cores      = 4
  memory_mb      = 8192
  disk_size_gb   = 100
  disk_datastore = "SAS_storage"
  ipv4_address   = "10.38.26.103/24"
}