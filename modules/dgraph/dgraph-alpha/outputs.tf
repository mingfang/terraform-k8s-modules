output "name" {
  value = module.statefulset-service.name
}

output "ports" {
  value = var.ports
}

output "service" {
  value = module.statefulset-service.service
}

output "statefulset" {
  value = module.statefulset-service.statefulset
}
