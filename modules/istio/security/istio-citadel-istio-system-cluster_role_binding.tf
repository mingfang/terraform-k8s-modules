resource "k8s_rbac_authorization_k8s_io_v1_cluster_role_binding" "istio-citadel-istio-system" {
  metadata {
    labels = {
      "app"      = "security"
      "chart"    = "security"
      "heritage" = "Tiller"
      "release"  = "istio"
    }
    name = "istio-citadel-istio-system"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "istio-citadel-istio-system"
  }

  subjects {
    kind      = "ServiceAccount"
    name      = "istio-citadel-service-account"
    namespace = "${var.namespace}"
  }
}