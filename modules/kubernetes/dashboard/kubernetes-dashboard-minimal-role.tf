resource "k8s_rbac_authorization_k8s_io_v1_role" "kubernetes-dashboard-minimal" {
  metadata {
    name      = "${var.name}-minimal"
    namespace = "${var.namespace}"
  }

  rules {
    api_groups = [
      "",
    ]
    resources = [
      "secrets",
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
    resource_names = [
      "kubernetes-dashboard-key-holder",
      "kubernetes-dashboard-certs",
    ]
    resources = [
      "secrets",
    ]
    verbs = [
      "get",
      "update",
      "delete",
    ]
  }
  rules {
    api_groups = [
      "",
    ]
    resource_names = [
      "kubernetes-dashboard-settings",
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
    resource_names = [
      "heapster",
    ]
    resources = [
      "services",
    ]
    verbs = [
      "proxy",
    ]
  }
  rules {
    api_groups = [
      "",
    ]
    resource_names = [
      "heapster",
      "http:heapster:",
      "https:heapster:",
    ]
    resources = [
      "services/proxy",
    ]
    verbs = [
      "get",
    ]
  }
}