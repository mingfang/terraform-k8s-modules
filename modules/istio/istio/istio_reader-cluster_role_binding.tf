resource "k8s_rbac_authorization_k8s_io_v1_cluster_role_binding" "istio_reader" {
  metadata {
    labels = {
      "chart" = "istio-1.5.2"
    }
    name = "istio-reader"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "istio-reader"
  }

  subjects {
    kind      = "ServiceAccount"
    name      = "istio-reader-service-account"
    namespace = var.namespace
  }
}