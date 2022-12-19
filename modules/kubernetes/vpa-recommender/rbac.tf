module "rbac" {
  source    = "../../../modules/kubernetes/rbac"
  name      = var.name
  namespace = var.namespace

  cluster_role_rules = [
    {
      api_groups = ["metrics.k8s.io"]
      resources  = ["pods"]
      verbs      = ["get", "list"]
    },
    {
      api_groups = [""]
      resources  = ["pods", "nodes", "limitranges"]
      verbs      = ["get", "list", "watch"]
    },
    {
      api_groups = [""]
      resources  = ["events"]
      verbs      = ["get", "list", "watch", "create"]
    },
    {
      api_groups = ["poc.autoscaling.k8s.io"]
      resources  = ["verticalpodautoscalers"]
      verbs      = ["get", "list", "watch", "patch"]
    },
    {
      api_groups = ["autoscaling.k8s.io"]
      resources  = ["verticalpodautoscalers", "verticalpodautoscalercheckpoints"]
      verbs      = ["get", "list", "watch", "create", "patch"]
    },
    {
      api_groups = ["*"]
      resources  = ["*/scale"]
      verbs      = ["get", "watch"]
    },
    {
      api_groups = [""]
      resources  = ["replicationcontrollers"]
      verbs      = ["get", "list", "watch"]
    }, {
      api_groups = ["apps"]
      resources  = ["daemonsets", "deployments", "replicasets", "statefulsets"]
      verbs      = ["get", "list", "watch"]
    }, {
      api_groups = ["batch"]
      resources  = ["jobs", "cronjobs"]
      verbs      = ["get", "list", "watch"]
    }
  ]
}