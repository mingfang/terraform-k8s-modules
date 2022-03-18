output "name" {
  value = var.name
}

output "deployment" {
  value = module.deployment-service.deployment
}