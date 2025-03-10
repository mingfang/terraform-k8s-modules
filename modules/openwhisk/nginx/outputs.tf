output "name" {
  value = var.name
}

output "ports" {
  value = var.ports
}

output "service" {
  value = module.nginx.service
}

output "deployment" {
  value = module.nginx.deployment
}
