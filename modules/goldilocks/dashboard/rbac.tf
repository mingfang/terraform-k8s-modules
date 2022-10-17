module "rbac" {
  source    = "../../../modules/kubernetes/rbac"
  name      = var.name
  namespace = var.namespace

  cluster_role_rules = [
    {
      api_groups = ["apps"]
      resources  = ["*"]
      verbs      = ["get", "list", "watch"]
    },
    {
      api_groups = [""]
      resources  = ["namespaces", "pods"]
      verbs      = ["get", "list", "watch"]
    },
    {
      api_groups = ["autoscaling.k8s.io"]
      resources  = ["verticalpodautoscalers"]
      verbs      = ["get", "list"]
    },
    {
      api_groups = ["argoproj.io"]
      resources  = ["rollouts"]
      verbs      = ["get", "list", "watch"]
    },
  ]
}