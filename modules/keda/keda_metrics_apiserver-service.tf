resource "k8s_core_v1_service" "keda_metrics_apiserver" {
  metadata {
    labels = {
      "app.kubernetes.io/name"    = "keda-metrics-apiserver"
      "app.kubernetes.io/part-of" = "keda-operator"
      "app.kubernetes.io/version" = "2.14.0"
    }
    name      = "keda-metrics-apiserver"
    namespace = k8s_core_v1_namespace.keda.metadata.0.name
  }
  spec {

    ports {
      name        = "https"
      port        = 443
      target_port = "6443"
    }
    ports {
      name        = "metrics"
      port        = 8080
      target_port = "8080"
    }
    selector = {
      "app" = "keda-metrics-apiserver"
    }
  }
}