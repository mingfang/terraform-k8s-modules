resource "k8s_rbac_authorization_k8s_io_v1beta1_cluster_role_binding" "enterprise-gateway-controller" {
  metadata {
    labels = {
      "app"       = "enterprise-gateway"
      "component" = "enterprise-gateway"
    }
    name = "enterprise-gateway-controller"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "enterprise-gateway-controller"
  }

  subjects {
    kind      = "ServiceAccount"
    name      = "enterprise-gateway-sa"
    namespace = k8s_core_v1_service.enterprise-gateway.metadata.0.namespace
  }
}