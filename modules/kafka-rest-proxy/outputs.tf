output "name" {
  value = module.deployment-service.name
}

output "port" {
  value = module.deployment-service.service.spec.0.ports.0.port
}

output "service" {
  value = module.deployment-service.service
}

output "deployment" {
  value = module.deployment-service.deployment
}
