output "name" {
  value = k8s_core_v1_service.this.metadata.0.name
}

output "service" {
  value = k8s_core_v1_service.this
}


output "deployment" {
  value = k8s_apps_v1_deployment.this
}
