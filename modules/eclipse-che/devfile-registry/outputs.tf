output "name" {
  value = k8s_core_v1_service.devfile_registry.metadata.0.name
}

output "service" {
  value = k8s_core_v1_service.devfile_registry
}

output "deployment" {
  value = k8s_apps_v1_deployment.devfile_registry
}
