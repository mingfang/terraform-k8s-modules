module "rbac" {
  source    = "../../../modules/kubernetes/rbac"
  name      = var.name
  namespace = var.namespace
  cluster_role_rules = concat(
    [
      {
        api_groups = [
          "",
        ]

        resources = [
          "configmaps",
        ]

        resource_names = [
          "extension-apiserver-authentication",
        ]

        verbs = [
          "get",
          "list",
        ]
      },
      {
        api_groups = [
          "admissionregistration.k8s.io",
        ]

        resources = [
          "mutatingwebhookconfigurations",
        ]

        verbs = [
          "get",
          "create",
          "delete",
        ]
      },
    ],
    var.rbac_cluster_role_rules
  )
}