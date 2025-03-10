module "rbac" {
  source    = "../../../modules/kubernetes/rbac"
  name      = var.name
  namespace = var.namespace

  cluster_role_rules = [
    {
      api_groups = ["openfaas.com"]
      resources  = ["functions"]
      verbs      = ["get", "list", "watch", "create", "delete", "update", "patch"]
    },
    {
      api_groups = [""]
      resources  = ["services"]
      verbs      = ["get", "list", "watch", "create", "delete", "update"]
    },
    {
      api_groups = ["extensions", "apps"]
      resources  = ["deployments"]
      verbs      = ["get", "list", "watch", "create", "delete", "update"]
    },
    {
      api_groups = [""]
      resources  = ["secrets"]
      verbs      = ["get", "list", "watch", "create", "delete", "update", "patch"]
    },
    {
      api_groups = [""]
      resources  = ["pods", "pods/log", "namespaces", "endpoints"]
      verbs      = ["get", "list", "watch"]
    },
  ]

}