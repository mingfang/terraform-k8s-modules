output "name" {
  value = var.name
}

output "service" {
  value = module.deployment-service.service
}

output "deployment" {
  value = module.deployment-service.deployment
}
