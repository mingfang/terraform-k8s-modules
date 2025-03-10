output "name" {
  value = module.deployment-service.name
}

output "ports" {
  value = var.ports
}

output "service" {
  value = module.deployment-service.service
}

output "deployment" {
  value = module.deployment-service.deployment
}
