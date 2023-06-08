module "rbac" {
  source    = "../../../modules/kubernetes/rbac"
  name      = var.name
  namespace = var.namespace

  cluster_role_rules = [
    {
      api_groups = ["apps"]
      resources  = ["replicasets"]
      verbs      = ["get", "list", "watch"]
    },
    {
      api_groups = [""]
      resources  = ["nodes", "nodes/proxy", "services", "endpoints", "pods"]
      verbs      = ["get", "list", "watch"]
    },
    {
      non_resource_urls = ["/metrics"]
      verbs             = ["get"]
    },
    {
      api_groups = ["metrics.k8s.io"]
      resources  = ["nodes", "pods"]
      verbs      = ["get", "list"]
    },
  ]
}