resource "k8s_apiregistration_k8s_io_v1_api_service" "v1beta1_external_metrics_k8s_io" {
  metadata {
    labels = {
      "app.kubernetes.io/name"    = "v1beta1.external.metrics.k8s.io"
      "app.kubernetes.io/part-of" = "keda-operator"
      "app.kubernetes.io/version" = "2.14.0"
    }
    name = "v1beta1.external.metrics.k8s.io"
  }
  spec {
    group                  = "external.metrics.k8s.io"
    group_priority_minimum = 100
    service {
      name      = "keda-metrics-apiserver"
      namespace = k8s_core_v1_namespace.keda.metadata.0.name
    }
    version          = "v1beta1"
    version_priority = 100
  }
}