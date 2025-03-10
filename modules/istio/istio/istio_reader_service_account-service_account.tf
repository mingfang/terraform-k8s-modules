resource "k8s_core_v1_service_account" "istio_reader_service_account" {
  metadata {
    name      = "istio-reader-service-account"
    namespace = var.namespace
  }
}