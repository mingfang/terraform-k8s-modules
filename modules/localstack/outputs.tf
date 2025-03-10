output "name" {
  value = var.name
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

output "ENDPOINT_URL" {
  value = "http://${var.name}.${var.namespace}:${var.ports.0.port}"
}