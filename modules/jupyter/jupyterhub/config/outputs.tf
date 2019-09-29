output "config_map" {
  value = k8s_core_v1_config_map.this
}

output "secret" {
  value = k8s_core_v1_secret.this
}