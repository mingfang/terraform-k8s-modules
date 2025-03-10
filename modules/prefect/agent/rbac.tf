module "rbac" {
  source    = "../../../modules/kubernetes/rbac"
  name      = var.name
  namespace = var.namespace

  cluster_role_rules = [
    {
      api_groups = ["batch", "extensions"]
      resources = ["jobs"]
      verbs = ["*"]
    },
    {
      api_groups = [""]
      resources = ["pods"]
      verbs = ["*"]
    },
  ]

}