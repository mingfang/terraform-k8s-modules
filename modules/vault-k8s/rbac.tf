module "rbac" {
  source    = "../../modules/kubernetes/rbac"
  name      = var.name
  namespace = var.namespace

  cluster_role_rules = [
    {
      api_groups = [
        "admissionregistration.k8s.io",
      ]
      resources = [
        "mutatingwebhookconfigurations",
      ]
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
      api_groups = [
        "",
      ]
      resources = [
        "endpoints",
        "secrets",
      ]
      verbs = [
        "create",
        "get",
        "watch",
        "list",
        "update",
      ]
    },
  ]
}
