resource "k8s_rbac_authorization_k8s_io_v1_role" "cert_manager_leaderelection" {
  metadata {
    labels = {
      "app"                         = "cert-manager"
      "app.kubernetes.io/component" = "controller"
      "app.kubernetes.io/instance"  = "cert-manager"
      "app.kubernetes.io/name"      = "cert-manager"
      "app.kubernetes.io/version"   = "v1.5.1"
    }
    name      = "cert-manager:leaderelection"
    namespace = "kube-system"
  }

  rules {
    api_groups = [
      "",
    ]
    resource_names = [
      "cert-manager-controller",
    ]
    resources = [
      "configmaps",
    ]
    verbs = [
      "get",
      "update",
      "patch",
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
      "coordination.k8s.io",
    ]
    resource_names = [
      "cert-manager-controller",
    ]
    resources = [
      "leases",
    ]
    verbs = [
      "get",
      "update",
      "patch",
    ]
  }
  rules {
    api_groups = [
      "coordination.k8s.io",
    ]
    resources = [
      "leases",
    ]
    verbs = [
      "create",
    ]
  }
}