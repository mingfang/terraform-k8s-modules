resource "k8s_core_v1_service_account" "keda_operator" {
  metadata {
    labels = {
      "app.kubernetes.io/name"    = "keda-operator"
      "app.kubernetes.io/part-of" = "keda-operator"
      "app.kubernetes.io/version" = "2.14.0"
    }
    name      = "keda-operator"
    namespace = k8s_core_v1_namespace.keda.metadata.0.name
  }
}