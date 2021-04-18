module "rbac" {
  source    = "../../../modules/kubernetes/rbac"
  name      = var.name
  namespace = var.namespace

  role_rules = [
    {
      api_groups = [
        "batch",
      ]
      resources = [
        "jobs",
        "jobs/status",
        "cronjobs",
      ]
      verbs = [
        "*",
      ]
    },
    {
      api_groups = [
        "",
      ]
      resources = [
        "pods",
        "pods/log",
        "pods/status",
      ]
      verbs = [
        "*",
      ]
    },
  ]
}