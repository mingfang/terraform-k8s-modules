resource "k8s_rbac_authorization_k8s_io_v1_role" "cert_manager_cainjector_leaderelection" {
  metadata {
    labels = {
      "app"                         = "cainjector"
      "app.kubernetes.io/component" = "cainjector"
      "app.kubernetes.io/instance"  = "cert-manager"
      "app.kubernetes.io/name"      = "cainjector"
      "app.kubernetes.io/version"   = "v1.5.1"
    }
    name      = "cert-manager-cainjector:leaderelection"
    namespace = "kube-system"
  }

  rules {
    api_groups = [
      "",
    ]
    resource_names = [
      "cert-manager-cainjector-leader-election",
      "cert-manager-cainjector-leader-election-core",
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
      "cert-manager-cainjector-leader-election",
      "cert-manager-cainjector-leader-election-core",
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