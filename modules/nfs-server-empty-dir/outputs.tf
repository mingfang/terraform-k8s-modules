output "name" {
  value = module.deployment-service.name
}

output "service" {
  value = module.deployment-service.service
}

output "deployment" {
  value = module.deployment-service.deployment
}

output "mount_options" {
  value = local.mount_options
}
