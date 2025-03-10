module "rbac" {
  source    = "../../../modules/kubernetes/rbac"
  name      = "airbyte-admin"
  namespace = var.namespace

  role_rules = [
    {
      api_groups = ["*"]
      resources  = ["jobs", "pods", "pods/log", "pods/exec", "pods/attach"]
      verbs : ["get", "list", "watch", "create", "update", "patch", "delete"]
    },
  ]
}