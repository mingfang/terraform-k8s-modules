resource "k8s_rbac_authorization_k8s_io_v1beta1_cluster_role" "enterprise-gateway-controller" {
  metadata {
    labels = {
      "app"       = "enterprise-gateway"
      "component" = "enterprise-gateway"
    }
    name = "enterprise-gateway-controller"
  }

  rules {
    api_groups = [
      "",
    ]
    resources = [
      "pods",
      "namespaces",
      "services",
      "configmaps",
      "secrets",
      "persistentvolumes",
      "persistentvolumeclaims",
    ]
    verbs = [
      "get",
      "watch",
      "list",
      "create",
      "delete",
    ]
  }
  rules {
    api_groups = [
      "rbac.authorization.k8s.io",
    ]
    resources = [
      "rolebindings",
    ]
    verbs = [
      "get",
      "list",
      "create",
      "delete",
    ]
  }
}