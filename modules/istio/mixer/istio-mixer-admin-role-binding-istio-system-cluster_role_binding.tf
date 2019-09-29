resource "k8s_rbac_authorization_k8s_io_v1_cluster_role_binding" "istio-mixer-admin-role-binding-istio-system" {
  metadata {
    labels = {
      "app"      = "mixer"
      "chart"    = "mixer"
      "heritage" = "Tiller"
      "release"  = "istio"
    }
    name = "istio-mixer-admin-role-binding-istio-system"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "istio-mixer-istio-system"
  }

  subjects {
    kind      = "ServiceAccount"
    name      = "istio-mixer-service-account"
    namespace = "${var.namespace}"
  }
}