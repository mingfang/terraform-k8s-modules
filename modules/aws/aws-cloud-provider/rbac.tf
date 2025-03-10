module "rbac" {
  source    = "../../../modules/kubernetes/rbac"
  name      = var.name
  namespace = var.namespace

  cluster_role_rules = [
    {
      api_groups     = [""]
      resource_names = ["node-controller", "service-controller", "route-controller"]
      resources      = ["serviceaccounts/token"]
      verbs          = ["create"]
    },
    {
      api_groups = [""]
      resources  = ["serviceaccounts"]
      verbs      = ["create", "get"]
    },
    {
      api_groups = [""]
      resources  = ["configmaps"]
      verbs      = ["get", "list", "watch"]
    },
    {
      api_groups = [""]
      resources  = ["events"]
      verbs      = ["create", "patch", "update"]
    },
    {
      api_groups = [""]
      resources  = ["nodes"]
      verbs      = ["*"]
    },
    {
      api_groups = [""]
      resources  = ["nodes/status"]
      verbs      = ["patch"]
    },
    {
      api_groups = ["coordination.k8s.io"]
      resources  = ["leases"]
      verbs      = ["create", "get", "list", "update", "watch"]
    },
  ]
}