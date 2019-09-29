resource "k8s_core_v1_service_account" "kubernetes-dashboard" {
  metadata {
    labels = {
      "k8s-app" = "${var.name}"
    }
    name      = "${var.name}"
    namespace = "${var.namespace}"
  }
}