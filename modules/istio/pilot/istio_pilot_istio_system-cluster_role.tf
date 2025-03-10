resource "k8s_rbac_authorization_k8s_io_v1_cluster_role" "istio_pilot_istio_system" {
  metadata {
    labels = {
      "app"      = "pilot"
      "chart"    = "pilot"
      "heritage" = "Tiller"
      "release"  = "istio"
    }
    name = "istio-pilot-istio-system"
  }

  rules {
    api_groups = [
      "config.istio.io",
      "rbac.istio.io",
      "security.istio.io",
      "networking.istio.io",
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
      "extensions",
    ]
    resources = [
      "ingresses",
      "ingresses/status",
    ]
    verbs = [
      "*",
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
      "get",
      "list",
      "watch",
      "update",
    ]
  }
  rules {
    api_groups = [
      "",
    ]
    resources = [
      "endpoints",
      "pods",
      "services",
      "namespaces",
      "nodes",
    ]
    verbs = [
      "get",
      "list",
      "watch",
    ]
  }
  rules {
    api_groups = [
      "discovery.k8s.io",
    ]
    resources = [
      "endpointslices",
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
      "secrets",
    ]
    verbs = [
      "create",
      "get",
      "watch",
      "list",
      "update",
      "delete",
    ]
  }
  rules {
    api_groups = [
      "certificates.k8s.io",
    ]
    resources = [
      "certificatesigningrequests",
      "certificatesigningrequests/approval",
      "certificatesigningrequests/status",
    ]
    verbs = [
      "update",
      "create",
      "get",
      "delete",
    ]
  }
}