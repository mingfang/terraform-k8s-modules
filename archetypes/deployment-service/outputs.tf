output "name" {
  value = k8s_apps_v1_deployment.this.metadata.0.name
}

output "labels" {
  value = local.labels
}

output "service" {
  value = length(k8s_core_v1_service.this) > 0 ? k8s_core_v1_service.this[0] : null
}


output "deployment" {
  value = k8s_apps_v1_deployment.this
}
