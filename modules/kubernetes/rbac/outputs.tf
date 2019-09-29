output "name" {
  value = k8s_core_v1_service_account.this.metadata.0.name
}

output "service_account" {
  value = k8s_core_v1_service_account.this
}