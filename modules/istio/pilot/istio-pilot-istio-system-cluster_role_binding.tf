resource "k8s_rbac_authorization_k8s_io_v1_cluster_role_binding" "istio-pilot-istio-system" {
  metadata {
    labels = {
      "app"      = "pilot"
      "chart"    = "pilot"
      "heritage" = "Tiller"
      "release"  = "istio"
    }
    name = "istio-pilot-istio-system"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "istio-pilot-istio-system"
  }

  subjects {
    kind      = "ServiceAccount"
    name      = "istio-pilot-service-account"
    namespace = "${var.namespace}"
  }
}