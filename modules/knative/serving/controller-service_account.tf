resource "k8s_core_v1_service_account" "controller" {
  metadata {
    labels = {
      "serving.knative.dev/release" = "devel"
    }
    name      = "controller"
    namespace = "${var.namespace}"
  }
}