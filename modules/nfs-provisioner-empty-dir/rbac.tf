module "rbac" {
  source    = "../../modules/kubernetes/rbac"
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
      verbs = [
        "get",
      ]
    },
    {
      api_groups = [
        "extensions",
      ]
      resource_names = [
        "nfs-provisioner",
      ]
      resources = [
        "podsecuritypolicies",
      ]
      verbs = [
        "use",
      ]
    },
  ]
  role_rules = [
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
    }
  ]
}
