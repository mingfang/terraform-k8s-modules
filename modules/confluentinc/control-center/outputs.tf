output "name" {
  value = module.deployment-service.name
}

output "ports" {
  value = module.deployment-service.service.spec.0.ports
}

output "service" {
  value = module.deployment-service.service
}

output "deployment" {
  value = module.deployment-service.deployment
}
