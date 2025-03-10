module "rbac" {
  source    = "../../../modules/kubernetes/rbac"
  name      = var.name
  namespace = var.namespace

  cluster_role_rules = [
    {
      api_groups = [""]
      resources  = ["configmaps", "secrets"]
      verbs      = ["get", "watch", "list"]
    },
  ]
}