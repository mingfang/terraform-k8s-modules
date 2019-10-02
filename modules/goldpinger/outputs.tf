output "name" {
  value = var.name
}

output "service" {
  value = k8s_core_v1_service.goldpinger
}