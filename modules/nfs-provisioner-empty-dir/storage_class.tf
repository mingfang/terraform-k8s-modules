resource "k8s_storage_k8s_io_v1_storage_class" "this" {
  metadata {
    name = var.storage_class
    annotations = {
      "storageclass.kubernetes.io/is-default-class" = var.is_default_class
    }
  }
  _provisioner = module.deployment-service.name

  allow_volume_expansion = var.allow_volume_expansion
  mount_options          = var.mount_options
  reclaim_policy         = var.reclaim_policy
}