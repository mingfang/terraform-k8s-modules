resource "k8s_core_v1_service" "keda_operator" {
  metadata {
    labels = {
      "app.kubernetes.io/name"    = "keda-operator"
      "app.kubernetes.io/part-of" = "keda-operator"
      "app.kubernetes.io/version" = "2.14.0"
    }
    name      = "keda-operator"
    namespace = k8s_core_v1_namespace.keda.metadata.0.name
  }
  spec {

    ports {
      name        = "metricsservice"
      port        = 9666
      target_port = "9666"
    }
    ports {
      name        = "metrics"
      port        = 8080
      target_port = "8080"
    }
    selector = {
      "app" = "keda-operator"
    }
  }
}