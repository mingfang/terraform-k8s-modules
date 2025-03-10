output "name" {
  value = var.name
}

output "service" {
  value = module.deployment-service.service
}

output "ports" {
  value = var.ports
}

output "deployment" {
  value = module.deployment-service.deployment
}
