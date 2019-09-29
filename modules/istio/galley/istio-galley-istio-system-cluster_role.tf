resource "k8s_rbac_authorization_k8s_io_v1_cluster_role" "istio-galley-istio-system" {
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
      "admissionregistration.k8s.io",
    ]
    resources = [
      "validatingwebhookconfigurations",
    ]
    verbs = [
      "*",
    ]
  }
  rules {
    api_groups = [
      "config.istio.io",
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
      "networking.istio.io",
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
      "rbac.istio.io",
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
      "extensions",
      "apps",
    ]
    resource_names = [
      "istio-galley",
    ]
    resources = [
      "deployments",
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
      "pods",
      "nodes",
      "services",
      "endpoints",
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
      "extensions",
    ]
    resource_names = [
      "istio-galley",
    ]
    resources = [
      "deployments/finalizers",
    ]
    verbs = [
      "update",
    ]
  }
}