module "rbac" {
  source    = "../../../modules/kubernetes/rbac"
  name      = var.name
  namespace = var.namespace

  cluster_role_rules = [
    {
      api_groups = [""]
      resources  = ["nodes"]
      verbs      = ["get", "list", "patch", "update"]
    },
    {
      api_groups = [""]
      resources  = ["pods"]
      verbs      = ["list"]
    },
    {
      api_groups = [""]
      resources  = ["pods/eviction"]
      verbs      = ["create"]
    },
    {
      api_groups = ["extensions"]
      resources  = ["daemonsets"]
      verbs      = ["get"]
    },
    {
      api_groups = ["apps"]
      resources  = ["daemonsets"]
      verbs      = ["get"]
    },
    {
      api_groups = [""]
      resources  = ["events"]
      verbs      = ["create", "patch"]
    }
  ]
  role_rules = [
    {
      api_groups = [""]
      resources : ["configmaps"]
      verbs : ["create", "list", "watch"]
    },
    {
      api_groups = [""]
      resources : ["configmaps"]
      resourceNames : ["cluster-autoscaler-status", "cluster-autoscaler-priority-expander"]
      verbs : ["delete", "get", "update", "watch"]
    }
  ]

}