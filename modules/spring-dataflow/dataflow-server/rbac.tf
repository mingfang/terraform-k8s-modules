module "rbac" {
  source    = "../../../modules/kubernetes/rbac"
  name      = var.name
  namespace = var.namespace

  role_rules = [
    {
      api_groups = [""]
      resources  = ["services", "pods", "replicationcontrollers", "persistentvolumeclaims"]
      verbs      = ["get", "list", "watch", "create", "delete", "update"]
    },
    {
      api_groups = [""]
      resources  = ["configmaps", "secrets", "pods/log", "pods/status"]
      verbs      = ["get", "list", "watch"]
    },
    {
      api_groups = ["apps"]
      resources  = ["statefulsets", "deployments", "replicasets"]
      verbs      = ["get", "list", "watch", "create", "delete", "update", "patch"]
    },
    {
      api_groups = ["extensions"]
      resources  = ["deployments", "replicasets"]
      verbs      = ["get", "list", "watch", "create", "delete", "update", "patch"]
    },
    {
      api_groups = ["batch"]
      resources  = ["cronjobs", "jobs"]
      verbs      = ["get", "list", "watch", "create", "delete", "update", "patch"]
    },
  ]
}