output "name" {
  value = var.name
}

output "service" {
  value = module.statefulset-service.service
}

output "ports" {
  value = var.ports
}

output "statefulset" {
  value = module.statefulset-service.statefulset
}
