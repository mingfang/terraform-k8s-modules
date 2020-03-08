output "name" {
  value = k8s_apps_v1_stateful_set.this.metadata.0.name
}

output "labels" {
  value = local.labels
}

output "service" {
  value = length(k8s_core_v1_service.this) > 0 ? k8s_core_v1_service.this[0] : null
}


output "statefulset" {
  value = k8s_apps_v1_stateful_set.this
}
