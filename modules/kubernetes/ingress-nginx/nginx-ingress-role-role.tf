resource "k8s_rbac_authorization_k8s_io_v1beta1_role" "nginx-ingress-role" {
  metadata {
    labels = {
      "app.kubernetes.io/name"    = var.name
      "app.kubernetes.io/part-of" = var.name
    }
    name      = var.name
    namespace = var.namespace
  }

  rules {
    api_groups = [
      "",
    ]
    resources = [
      "configmaps",
      "pods",
      "secrets",
      "namespaces",
    ]
    verbs = [
      "get",
    ]
  }
  rules {
    api_groups = [
      "",
    ]
    resource_names = [
      "${var.name}-${var.ingress_class}",
    ]
    resources = [
      "configmaps",
    ]
    verbs = [
      "get",
      "update",
    ]
  }
  rules {
    api_groups = [
      "",
    ]
    resources = [
      "configmaps",
    ]
    verbs = [
      "create",
    ]
  }
  rules {
    api_groups = [
      "",
    ]
    resources = [
      "endpoints",
    ]
    verbs = [
      "get",
    ]
  }
}