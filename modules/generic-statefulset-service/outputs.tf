output "name" {
  value = var.name
}

output "ports" {
  value = local.ports
}

output "service" {
  value = module.statefulset-service.service
}

output "statefulset" {
  value = module.statefulset-service.statefulset
}
