output storage_class_name {
  value = length(k8s_core_v1_persistent_volume_claim.this) > 0 ? element(k8s_core_v1_persistent_volume_claim.this.*.spec.0.storage_class_name, 0) : ""
}

output storage {
  value = length(k8s_core_v1_persistent_volume_claim.this) > 0 ? element(k8s_core_v1_persistent_volume_claim.this.*.spec.0.resources.0.requests.storage, 0) : ""
}

output replicas {
  value = var.replicas
}
