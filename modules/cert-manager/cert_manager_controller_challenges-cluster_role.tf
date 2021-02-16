resource "k8s_rbac_authorization_k8s_io_v1_cluster_role" "cert_manager_controller_challenges" {
  metadata {
    labels = {
      "app"                         = "cert-manager"
      "app.kubernetes.io/component" = "controller"
      "app.kubernetes.io/instance"  = "cert-manager"
      "app.kubernetes.io/name"      = "cert-manager"
    }
    name = "cert-manager-controller-challenges"
  }

  rules {
    api_groups = [
      "acme.cert-manager.io",
    ]
    resources = [
      "challenges",
      "challenges/status",
    ]
    verbs = [
      "update",
    ]
  }
  rules {
    api_groups = [
      "acme.cert-manager.io",
    ]
    resources = [
      "challenges",
    ]
    verbs = [
      "get",
      "list",
      "watch",
    ]
  }
  rules {
    api_groups = [
      "cert-manager.io",
    ]
    resources = [
      "issuers",
      "clusterissuers",
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
      "",
    ]
    resources = [
      "pods",
      "services",
    ]
    verbs = [
      "get",
      "list",
      "watch",
      "create",
      "delete",
    ]
  }
  rules {
    api_groups = [
      "networking.k8s.io",
    ]
    resources = [
      "ingresses",
    ]
    verbs = [
      "get",
      "list",
      "watch",
      "create",
      "delete",
      "update",
    ]
  }
  rules {
    api_groups = [
      "route.openshift.io",
    ]
    resources = [
      "routes/custom-host",
    ]
    verbs = [
      "create",
    ]
  }
  rules {
    api_groups = [
      "acme.cert-manager.io",
    ]
    resources = [
      "challenges/finalizers",
    ]
    verbs = [
      "update",
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
      "get",
      "list",
      "watch",
    ]
  }
}