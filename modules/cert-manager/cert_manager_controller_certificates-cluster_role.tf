resource "k8s_rbac_authorization_k8s_io_v1_cluster_role" "cert_manager_controller_certificates" {
  metadata {
    labels = {
      "app"                         = "cert-manager"
      "app.kubernetes.io/component" = "controller"
      "app.kubernetes.io/instance"  = "cert-manager"
      "app.kubernetes.io/name"      = "cert-manager"
      "app.kubernetes.io/version"   = "v1.5.1"
    }
    name = "cert-manager-controller-certificates"
  }

  rules {
    api_groups = [
      "cert-manager.io",
    ]
    resources = [
      "certificates",
      "certificates/status",
      "certificaterequests",
      "certificaterequests/status",
    ]
    verbs = [
      "update",
    ]
  }
  rules {
    api_groups = [
      "cert-manager.io",
    ]
    resources = [
      "certificates",
      "certificaterequests",
      "clusterissuers",
      "issuers",
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
      "certificates/finalizers",
      "certificaterequests/finalizers",
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
      "orders",
    ]
    verbs = [
      "create",
      "delete",
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
      "create",
      "update",
      "delete",
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
}