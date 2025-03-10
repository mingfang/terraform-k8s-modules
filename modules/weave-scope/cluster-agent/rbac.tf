module "rbac" {
  source    = "../../../modules/kubernetes/rbac"
  name      = var.name
  namespace = var.namespace

  cluster_role_rules = [
    {
      api_groups = [
        "",
      ]
      resources = [
        "pods",
      ]
      verbs = [
        "get",
        "list",
        "watch",
        "delete",
      ]
    },
    {
      api_groups = [
        "",
      ]
      resources = [
        "pods/log",
        "services",
        "nodes",
        "namespaces",
        "persistentvolumes",
        "persistentvolumeclaims",
      ]
      verbs = [
        "get",
        "list",
        "watch",
      ]
    },
    {
      api_groups = [
        "apps",
      ]
      resources = [
        "deployments",
        "daemonsets",
        "statefulsets",
      ]
      verbs = [
        "get",
        "list",
        "watch",
      ]
    },
    {
      api_groups = [
        "batch",
      ]
      resources = [
        "cronjobs",
        "jobs",
      ]
      verbs = [
        "get",
        "list",
        "watch",
      ]
    },
    {
      api_groups = [
        "extensions",
      ]
      resources = [
        "deployments",
        "daemonsets",
      ]
      verbs = [
        "get",
        "list",
        "watch",
      ]
    },
    {
      api_groups = [
        "apps",
      ]
      resources = [
        "deployments/scale",
      ]
      verbs = [
        "get",
        "update",
      ]
    },
    {
      api_groups = [
        "extensions",
      ]
      resources = [
        "deployments/scale",
      ]
      verbs = [
        "get",
        "update",
      ]
    },
    {
      api_groups = [
        "storage.k8s.io",
      ]
      resources = [
        "storageclasses",
      ]
      verbs = [
        "get",
        "list",
        "watch",
      ]
    },
    {
      api_groups = [
        "volumesnapshot.external-storage.k8s.io",
      ]
      resources = [
        "volumesnapshots",
        "volumesnapshotdatas",
      ]
      verbs = [
        "list",
        "watch",
      ]
    },
  ]
}
