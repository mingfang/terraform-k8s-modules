resource "k8s_rbac_authorization_k8s_io_v1beta1_cluster_role" "nginx-ingress-clusterrole" {
  metadata {
    labels = {
      "app.kubernetes.io/name"    = var.name
      "app.kubernetes.io/part-of" = var.name
    }
    name = var.name
  }

  rules {
    api_groups = [
      "",
    ]
    resources = [
      "configmaps",
      "endpoints",
      "nodes",
      "pods",
      "secrets",
    ]
    verbs = [
      "list",
      "watch",
    ]
  }
  rules {
    api_groups = [
      "",
    ]
    resources = [
      "nodes",
    ]
    verbs = [
      "get",
    ]
  }
  rules {
    api_groups = [
      "",
    ]
    resources = [
      "services",
    ]
    verbs = [
      "get",
      "list",
      "watch",
    ]
  }
  rules {
    api_groups = [
      "",
    ]
    resources = [
      "events",
    ]
    verbs = [
      "create",
      "patch",
    ]
  }
  rules {
    api_groups = [
      "extensions",
      "networking.k8s.io",
    ]
    resources = [
      "ingresses",
    ]
    verbs = [
      "get",
      "list",
      "watch",
    ]
  }
  rules {
    api_groups = [
      "extensions",
      "networking.k8s.io",
    ]
    resources = [
      "ingresses/status",
    ]
    verbs = [
      "update",
    ]
  }
}