resource "k8s_rbac_authorization_k8s_io_v1_cluster_role" "keda_external_metrics_reader" {
  metadata {
    labels = {
      "app.kubernetes.io/name"    = "keda-external-metrics-reader"
      "app.kubernetes.io/part-of" = "keda-operator"
      "app.kubernetes.io/version" = "2.14.0"
    }
    name = "keda-external-metrics-reader"
  }

  rules {
    api_groups = [
      "external.metrics.k8s.io",
    ]
    resources = [
      "*",
    ]
    verbs = [
      "*",
    ]
  }
}