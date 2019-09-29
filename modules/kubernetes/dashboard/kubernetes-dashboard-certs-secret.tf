resource "k8s_core_v1_secret" "kubernetes-dashboard-certs" {
  metadata {
    labels = {
      "k8s-app" = "${var.name}"
    }
    name      = "${var.name}-certs"
    namespace = "${var.namespace}"
  }
  type = "Opaque"
}