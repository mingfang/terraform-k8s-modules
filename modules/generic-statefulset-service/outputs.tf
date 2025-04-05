output "name" {
  value = var.name
}

output "ports" {
  value = local.ports
}

output "ports_map" {
  value = local.ports_map
}

output "service" {
  value = module.statefulset-service.service
}

output "statefulset" {
  value = module.statefulset-service.statefulset
}
