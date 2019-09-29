resource "k8s_rbac_authorization_k8s_io_v1_cluster_role_binding" "istio-kiali-admin-role-binding-istio-system" {
  metadata {
    labels = {
      "app"      = "kiali"
      "chart"    = "kiali"
      "heritage" = "Tiller"
      "release"  = "istio"
    }
    name = "istio-kiali-admin-role-binding-istio-system"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "kiali"
  }

  subjects {
    kind      = "ServiceAccount"
    name      = "kiali-service-account"
    namespace = "${var.namespace}"
  }
}