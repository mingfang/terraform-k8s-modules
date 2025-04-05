output "name" {
  value = var.name
}

output "ports" {
  value = local.ports
}

output "ports_map" {
  value = local.ports_map
}

output "service" {
  value = module.deployment-service.service
}

output "deployment" {
  value = module.deployment-service.deployment
}
