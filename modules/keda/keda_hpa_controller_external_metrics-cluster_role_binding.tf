resource "k8s_rbac_authorization_k8s_io_v1_cluster_role_binding" "keda_hpa_controller_external_metrics" {
  metadata {
    labels = {
      "app.kubernetes.io/name"    = "keda-hpa-controller-external-metrics"
      "app.kubernetes.io/part-of" = "keda-operator"
      "app.kubernetes.io/version" = "2.14.0"
    }
    name = "keda-hpa-controller-external-metrics"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "keda-external-metrics-reader"
  }

  subjects {
    kind      = "ServiceAccount"
    name      = "horizontal-pod-autoscaler"
    namespace = "kube-system"
  }
}