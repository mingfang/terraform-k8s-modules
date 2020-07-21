module "rbac" {
  source    = "../../../modules/kubernetes/rbac"
  name      = var.name
  namespace = var.namespace

  cluster_role_rules = [
    {
      api_groups = [""]
      resources = ["pods"]
      verbs = ["create", "get", "delete", "list", "watch"]
    },
    {
      api_groups = [""]
      resources = ["pods/log"]
      verbs = ["get", "list"]
    },
    {
      api_groups = [""]
      resources = ["pods/exec"]
      verbs = ["create", "get"]
    },
  ]

}