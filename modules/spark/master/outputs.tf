output "name" {
  value = module.deployment-service.name
}

output "service" {
  value = module.deployment-service.service
}

output "deployment" {
  value = module.deployment-service.deployment
}

output "master_url" {
  value = "spark://${module.deployment-service.name}:${module.deployment-service.service.spec.0.ports.0.port}"
}