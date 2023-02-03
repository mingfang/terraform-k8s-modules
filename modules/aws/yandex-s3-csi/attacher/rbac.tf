module "rbac" {
  source    = "../../../../modules/kubernetes/rbac"
  name      = var.name
  namespace = var.namespace

  cluster_role_rules = [
    {
      api_groups = [""]
      resources  = ["secrets"]
      verbs      = ["get", "list"]
    },
    {
      api_groups = [""]
      resources  = ["events"]
      verbs      = ["get", "list", "watch", "update"]
    },
    {
      api_groups = [""]
      resources  = ["persistentvolumes"]
      verbs      = ["get", "list", "watch", "update"]
    },
    {
      api_groups = [""]
      resources  = ["nodes"]
      verbs      = ["get", "list", "watch"]
    },
    {
      api_groups = ["storage.k8s.io"]
      resources  = ["csinodes"]
      verbs      = ["get", "list", "watch"]
    },
    {
      api_groups = ["storage.k8s.io"]
      resources  = ["volumeattachments"]
      verbs      = ["get", "list", "watch", "update", "patch"]
    },
    {
      api_groups = ["storage.k8s.io"]
      resources  = ["volumeattachments/status"]
      verbs      = ["patch"]
    }
  ]
}