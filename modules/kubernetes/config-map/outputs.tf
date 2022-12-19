output "name" {
  value = k8s_core_v1_config_map.this.metadata[0].name
}

output "config_map" {
  value = k8s_core_v1_config_map.this
}

output "checksum" {
  value = md5(join("", keys(local.data), values(local.data)))
}

output "config_map_ref" {
  value = { config_map_ref = { name = var.name } }
}