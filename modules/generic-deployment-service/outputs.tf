output "name" {
  value = var.name
}

output "ports" {
  value = local.ports
}

output "service" {
  value = module.deployment-service.service
}

output "deployment" {
  value = module.deployment-service.deployment
}
