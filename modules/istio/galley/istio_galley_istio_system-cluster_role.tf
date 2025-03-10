resource "k8s_rbac_authorization_k8s_io_v1_cluster_role" "istio_galley_istio_system" {
  metadata {
    labels = {
      "app"      = "galley"
      "chart"    = "galley"
      "heritage" = "Tiller"
      "release"  = "istio"
    }
    name = "istio-galley-istio-system"
  }

  rules {
    api_groups = [
      "authentication.istio.io",
      "config.istio.io",
      "networking.istio.io",
      "rbac.istio.io",
      "security.istio.io",
    ]
    resources = [
      "*",
    ]
    verbs = [
      "get",
      "list",
      "watch",
    ]
  }
  rules {
    api_groups = [
      "authentication.istio.io",
      "config.istio.io",
      "networking.istio.io",
      "rbac.istio.io",
      "security.istio.io",
    ]
    resources = [
      "*/status",
    ]
    verbs = [
      "update",
    ]
  }
  rules {
    api_groups = [
      "admissionregistration.k8s.io",
    ]
    resources = [
      "validatingwebhookconfigurations",
    ]
    verbs = [
      "get",
      "list",
      "watch",
      "update",
    ]
  }
  rules {
    api_groups = [
      "networking.istio.io",
    ]
    resources = [
      "gateways",
    ]
    verbs = [
      "create",
    ]
  }
  rules {
    api_groups = [
      "extensions",
      "apps",
    ]
    resources = [
      "deployments",
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
      "pods",
      "nodes",
      "services",
      "endpoints",
      "namespaces",
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
      "apiextensions.k8s.io",
    ]
    resources = [
      "customresourcedefinitions",
    ]
    verbs = [
      "get",
      "list",
      "watch",
    ]
  }
  rules {
    api_groups = [
      "rbac.authorization.k8s.io",
    ]
    resources = [
      "clusterroles",
    ]
    verbs = [
      "get",
      "list",
      "watch",
    ]
  }
}