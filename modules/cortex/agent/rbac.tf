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
        "nodes",
        "nodes/proxy",
        "services",
        "endpoints",
        "pods",
      ]

      verbs = [
        "get",
        "list",
        "watch",
      ]
    },
    {
      non_resource_urls = [
        "/metrics"
      ]

      verbs = [
        "get"
      ]
    }
  ]
}