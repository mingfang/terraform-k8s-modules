output storage_class_name {
  value = element(k8s_core_v1_persistent_volume_claim.this.*.spec.0.storage_class_name, 0)
}

output storage {
  value = element(k8s_core_v1_persistent_volume_claim.this.*.spec.0.resources.0.requests.storage, 0)
}

output replicas {
  value = var.replicas
}
