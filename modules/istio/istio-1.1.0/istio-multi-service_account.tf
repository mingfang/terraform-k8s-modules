resource "k8s_core_v1_service_account" "istio-multi" {
  metadata {
    name      = "istio-multi"
    namespace = "${var.namespace}"
  }
}