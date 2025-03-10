module "rbac" {
  source    = "../../../modules/kubernetes/rbac"
  name      = var.name
  namespace = var.namespace

  role_rules = [
    {
      api_groups = [""]
      resources  = ["pods"]
      verbs      = ["create", "delete", "get", "list", "patch", "update", "watch"]
    },
    {
      api_groups = [""]
      resources  = ["pods/exec"]
      verbs      = ["create", "delete", "get", "list", "patch", "update", "watch"]
    },
    {
      api_groups = [""]
      resources  = ["pods/log"]
      verbs      = ["get", "list", "watch"]
    },
    {
      api_groups = [""]
      resources  = ["events"]
      verbs      = ["watch"]
    },
    {
      api_groups = [""]
      resources  = ["secrets"]
      verbs      = ["get"]
    },
  ]
}