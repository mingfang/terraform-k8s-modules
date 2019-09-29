resource "k8s_storage_k8s_io_v1_storage_class" "this" {
  metadata {
    name = var.name
  }
  _provisioner = module.deployment-service.name
}