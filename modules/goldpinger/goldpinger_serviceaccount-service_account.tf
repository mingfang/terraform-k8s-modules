resource "k8s_core_v1_service_account" "goldpinger_serviceaccount" {
  metadata {
    name      = "${var.name}-serviceaccount"
    namespace = "${var.namespace}"
  }
}