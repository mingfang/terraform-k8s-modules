resource "k8s_rbac_authorization_k8s_io_v1_cluster_role_binding" "istio-galley-admin-role-binding-istio-system" {
  metadata {
    labels = {
      "app"      = "galley"
      "chart"    = "galley"
      "heritage" = "Tiller"
      "release"  = "istio"
    }
    name = "istio-galley-admin-role-binding-istio-system"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "istio-galley-istio-system"
  }

  subjects {
    kind      = "ServiceAccount"
    name      = "istio-galley-service-account"
    namespace = "${var.namespace}"
  }
}