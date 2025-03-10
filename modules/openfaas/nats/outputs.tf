output "name" {
  value = module.deployment-service.name
}

output "service" {
  value = module.deployment-service.service
}

output "deployment" {
  value = module.deployment-service.deployment
}

output "cluster_id" {
  value = var.cluster_id
}