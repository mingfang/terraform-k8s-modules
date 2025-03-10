resource "k8s_rbac_authorization_k8s_io_v1_role" "keda_operator" {
  metadata {
    labels = {
      "app.kubernetes.io/name"    = "keda-operator"
      "app.kubernetes.io/part-of" = "keda-operator"
      "app.kubernetes.io/version" = "2.14.0"
    }
    name      = "keda-operator"
    namespace = k8s_core_v1_namespace.keda.metadata.0.name
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
      "delete",
      "get",
      "list",
      "patch",
      "update",
      "watch",
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
      "*",
    ]
  }
}