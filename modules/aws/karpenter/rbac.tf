module "rbac" {
  source    = "../../../modules/kubernetes/rbac"
  name      = var.name
  namespace = var.namespace

  cluster_role_rules = [
    {
      api_groups = ["karpenter.sh"]
      resources  = ["provisioners", "provisioners/status"]
      verbs      = ["create", "delete", "patch", "get", "list", "watch"]
    },
    {
      api_groups = ["coordination.k8s.io"]
      resources  = ["leases"]
      verbs      = ["create", "get", "patch", "update", "watch"]
    },
    {
      api_groups = [""]
      resources  = ["nodes", "pods"]
      verbs      = ["get", "list", "watch", "patch", "delete"]
    },
    {
      api_groups = [""]
      resources  = ["configmaps"]
      verbs      = ["get", "list", "watch", "update"]
    },
    {
      api_groups = [""]
      resources  = ["nodes"]
      verbs      = ["create"]
    },
    {
      api_groups = [""]
      resources  = ["pods/binding", "pods/eviction"]
      verbs      = ["create"]
    },
    {
      api_groups = ["apps"]
      resources  = ["daemonsets"]
      verbs      = ["list", "watch"]
    }
  ]

  role_rules = [
    {
      api_groups = [""]
      resources  = ["configmaps"]
      verbs      = ["get", "list", "watch", "create", "update", "patch", "delete"]
    },
    {
      api_groups = [""]
      resources  = ["configmaps/status"]
      verbs      = ["get", "update", "patch"]
    },
    {
      api_groups = [""]
      resources  = ["events"]
      verbs      = ["create"]
    }
  ]
}