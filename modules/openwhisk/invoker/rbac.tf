module "rbac" {
  source    = "../../kubernetes/rbac"
  name      = var.name
  namespace = var.namespace

  role_rules = [
    {
      api_groups = [
        "extensions",
        "apps",
      ]
      resources = [
        "deployments",
      ]
      verbs = [
        "get",
        "list",
        "watch",
        "create",
        "update",
        "patch",
        "delete",
      ]
    },
    {
      api_groups = [
        "",
      ]
      resources = [
        "pods",
      ]
      verbs = [
        "get",
        "list",
        "watch",
        "create",
        "update",
        "patch",
        "delete",
      ]
    },
    {
      api_groups = [
        "",
      ]
      resources = [
        "pods/log",
      ]
      verbs = [
        "get",
        "list",
      ]
    },
  ]

}