output "name" {
  value = k8s_core_v1_service.this.metadata.0.name
}

output "labels" {
  value = local.labels
}

output "service" {
  value = k8s_core_v1_service.this
}


output "statefulset" {
  value = k8s_apps_v1_stateful_set.this
}
