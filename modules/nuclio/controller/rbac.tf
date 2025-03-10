module "rbac" {
  source    = "../../kubernetes/rbac"
  name      = var.name
  namespace = var.namespace

  cluster_role_rules = [
    {
      api_groups = [""]
      resources  = ["nodes"]
      verbs      = ["get", "list"]
    },
    {
      api_groups = ["nuclio.io"]
      resources  = ["nucliofunctions", "nuclioprojects", "nucliofunctionevents", "nuclioapigateways"]
      verbs      = ["*"]
    },
    {
      api_groups = [""]
      resources  = ["namespaces"]
      verbs      = ["list"]
    },
    {
      api_groups = [""]
      resources  = ["services", "configmaps", "pods", "pods/log", "events", "secrets"]
      verbs      = ["*"]
    },
    {
      api_groups = ["apps", "extensions"]
      resources  = ["deployments"]
      verbs      = ["*"]
    },
    {
      api_groups = ["networking.k8s.io"]
      resources  = ["ingresses"]
      verbs      = ["*"]
    },
    {
      api_groups = ["autoscaling"]
      resources  = ["horizontalpodautoscalers"]
      verbs      = ["*"]
    },
    {
      api_groups = ["metrics.k8s.io", "custom.metrics.k8s.io"]
      resources  = ["*"]
      verbs      = ["*"]
    },
    {
      api_groups = ["batch"]
      resources  = ["jobs", "cronjobs"]
      verbs      = ["*"]
    },
  ]
}