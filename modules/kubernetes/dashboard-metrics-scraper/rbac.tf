module "rbac" {
  source    = "../../../modules/kubernetes/rbac"
  name      = var.name
  namespace = var.namespace

  cluster_role_rules = [
    {
      api_groups : [
        "metrics.k8s.io",
      ]
      resources : [
        "pods",
        "nodes",
      ]
      verbs : [
        "get",
        "list",
        "watch",
      ]
    }
  ]
}
