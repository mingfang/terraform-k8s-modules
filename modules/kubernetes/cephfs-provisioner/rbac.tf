module "rbac" {
  source    = "../rbac"
  name      = var.name
  namespace = var.namespace
  cluster_role_rules = [
    {
      api_groups = [
        "",
      ]
      resources = [
        "persistentvolumes",
      ]
      verbs = [
        "get",
        "list",
        "watch",
        "create",
        "delete",
      ]
    },
    {
      api_groups = [
        "",
      ]
      resources = [
        "persistentvolumeclaims",
      ]
      verbs = [
        "get",
        "list",
        "watch",
        "update",
      ]
    },
    {
      api_groups = [
        "storage.k8s.io",
      ]
      resources = [
        "storageclasses",
      ]
      verbs = [
        "get",
        "list",
        "watch",
      ]
    },
    {
      api_groups = [
        "",
      ]
      resources = [
        "events",
      ]
      verbs = [
        "create",
        "update",
        "patch",
      ]
    },
    {
      api_groups = [
        "",
      ]
      resources = [
        "services",
        "endpoints",
      ]
      resource_names = [
        "kube-dns",
        "coredns",
      ]
      verbs = [
        "list",
        "get",
      ]
    },
    {
      api_groups = [
        "",
      ]
      resources = [
        "secrets",
      ]
      verbs = [
        "create",
        "get",
        "delete",
      ]
    },
    {
      api_groups = [
        "",
      ]
      resources = [
        "endpoints",
      ]
      verbs = [
        "get",
        "list",
        "watch",
        "create",
        "update",
        "patch",
      ]
    },
  ]
}
