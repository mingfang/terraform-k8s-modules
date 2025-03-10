module "rbac" {
  source    = "../../../modules/kubernetes/rbac"
  name      = var.name
  namespace = var.namespace
  cluster_role_rules = [
    {
      api_groups = [
        "",
      ]

      resources = [
        "endpoints",
        "namespaces",
        "nodes",
        "nodes/proxy",
        "pods",
        "services",
      ]

      verbs = [
        "get",
        "list",
        "watch",
      ]
    },
  ]
}