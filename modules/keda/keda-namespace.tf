resource "k8s_core_v1_namespace" "keda" {
  metadata {
    labels = {
      "app.kubernetes.io/name"    = "keda"
      "app.kubernetes.io/part-of" = "keda-operator"
      "app.kubernetes.io/version" = "2.14.0"
    }
    name = var.namespace
  }
}