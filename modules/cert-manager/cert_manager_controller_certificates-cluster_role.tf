resource "k8s_rbac_authorization_k8s_io_v1beta1_cluster_role" "cert_manager_controller_certificates" {
  metadata {
    labels = {
      "app"                          = "cert-manager"
      "app.kubernetes.io/instance"   = "cert-manager"
      "app.kubernetes.io/managed-by" = "Tiller"
      "app.kubernetes.io/name"       = "cert-manager"
      "helm.sh/chart"                = "cert-manager-v0.10.1"
    }
    name = "cert-manager-controller-certificates"
  }

  rules {
    api_groups = [
      "certmanager.k8s.io",
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
      "certmanager.k8s.io",
    ]
    resources = [
      "certificates",
      "certificaterequests",
      "clusterissuers",
      "issuers",
      "orders",
    ]
    verbs = [
      "get",
      "list",
      "watch",
    ]
  }
  rules {
    api_groups = [
      "certmanager.k8s.io",
    ]
    resources = [
      "certificates/finalizers",
    ]
    verbs = [
      "update",
    ]
  }
  rules {
    api_groups = [
      "certmanager.k8s.io",
    ]
    resources = [
      "orders",
    ]
    verbs = [
      "create",
      "delete",
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