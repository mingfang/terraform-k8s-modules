resource "k8s_rbac_authorization_k8s_io_v1_cluster_role" "cert_manager_cainjector" {
  metadata {
    labels = {
      "app"                         = "cainjector"
      "app.kubernetes.io/component" = "cainjector"
      "app.kubernetes.io/instance"  = "cert-manager"
      "app.kubernetes.io/name"      = "cainjector"
    }
    name = "cert-manager-cainjector"
  }

  rules {
    api_groups = [
      "cert-manager.io",
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
  rules {
    api_groups = [
      "auditregistration.k8s.io",
    ]
    resources = [
      "auditsinks",
    ]
    verbs = [
      "get",
      "list",
      "watch",
      "update",
    ]
  }
}