resource "k8s_rbac_authorization_k8s_io_v1beta1_cluster_role" "cert_manager_cainjector" {
  metadata {
    labels = {
      "app"                          = "cainjector"
      "app.kubernetes.io/instance"   = "cert-manager"
      "app.kubernetes.io/managed-by" = "Tiller"
      "app.kubernetes.io/name"       = "cainjector"
      "helm.sh/chart"                = "cainjector-v0.10.1"
    }
    name = "cert-manager-cainjector"
  }

  rules {
    api_groups = [
      "certmanager.k8s.io",
    ]
    resources = [
      "certificates",
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
      "configmaps",
      "events",
    ]
    verbs = [
      "get",
      "create",
      "update",
      "patch",
    ]
  }
  rules {
    api_groups = [
      "admissionregistration.k8s.io",
    ]
    resources = [
      "validatingwebhookconfigurations",
      "mutatingwebhookconfigurations",
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
      "apiregistration.k8s.io",
    ]
    resources = [
      "apiservices",
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
      "apiextensions.k8s.io",
    ]
    resources = [
      "customresourcedefinitions",
    ]
    verbs = [
      "get",
      "list",
      "watch",
      "update",
    ]
  }
}