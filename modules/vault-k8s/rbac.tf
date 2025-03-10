module "rbac" {
  source    = "../../modules/kubernetes/rbac"
  name      = var.name
  namespace = var.namespace

  cluster_role_rules = [
    {
      api_groups = ["admissionregistration.k8s.io"]
      resources  = ["mutatingwebhookconfigurations"]
      verbs = [
        "get",
        "list",
        "watch",
        "patch",
      ]
    },
  ]

  role_rules = [
    {
      api_groups = [""]
      resources  = ["secrets", "configmaps"]
      verbs = [
        "create",
        "get",
        "watch",
        "list",
        "update",
      ]
    },
    {
      api_groups = [""]
      resources  = ["pods"]
      verbs = [
        "get",
        "patch",
        "delete",
      ]
    },
  ]
}
