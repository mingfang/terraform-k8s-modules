output "name" {
  value = module.deployment-service.name
}

output "service" {
  value = module.deployment-service.service
}

output "deployment" {
  value = module.deployment-service.deployment
}

output "storage_class" {
  value = k8s_storage_k8s_io_v1_storage_class.this.metadata[0].name
}
