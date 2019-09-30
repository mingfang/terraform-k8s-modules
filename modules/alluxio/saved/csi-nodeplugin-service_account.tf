resource "k8s_core_v1_service_account" "csi-nodeplugin" {
  metadata {
    name      = "csi-nodeplugin"
    namespace = var.namespace
  }
}