output "name" {
  value = k8s_core_v1_config_map.this.metadata[0].name
}