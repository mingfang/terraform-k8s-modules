output "config_map" {
  value = k8s_core_v1_config_map.this
}

output "secret" {
  value = k8s_core_v1_secret.this
}

output "config_checksum" {
  value = md5(join("", keys(k8s_core_v1_config_map.this.data), values(k8s_core_v1_config_map.this.data)))
}

output "secret_checksum" {
  value = md5(join("", keys(k8s_core_v1_secret.this.data), values(k8s_core_v1_secret.this.data)))
}