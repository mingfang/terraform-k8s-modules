output "name" {
  value = var.name
}

output "image" {
  value = var.image
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
