/**
 * Documentation
 *
 * terraform-docs --sort-inputs-by-required --with-aggregate-type-defaults md
 *
 */

locals {
  labels = {
    app     = var.name
    name    = var.name
    service = var.name
  }

  parameters = {
    name      = var.name
    namespace = var.namespace
    labels    = local.labels
  }

  cluster_role_parameters = {
    name = "${var.namespace}:${var.name}"
  }

  cluster_role_rules = var.cluster_role_rules == null ? [] : var.cluster_role_rules
  role_rules         = var.role_rules == null ? [] : var.role_rules

  cluster_role_ref = {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = local.cluster_role_parameters.name
  }

  role_ref = {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = var.name
  }

  subjects = [
    {
      api_group = ""
      kind      = "ServiceAccount"
      name      = k8s_core_v1_service_account.this.metadata.0.name
      namespace = k8s_core_v1_service_account.this.metadata.0.namespace
    }
  ]

  k8s_core_v1_service_account_parameters                           = merge(local.parameters, var.overrides)
  k8s_rbac_authorization_k8s_io_v1_cluster_role_parameters         = merge(local.cluster_role_parameters, { rules = local.cluster_role_rules }, var.overrides)
  k8s_rbac_authorization_k8s_io_v1_cluster_role_binding_parameters = merge(local.cluster_role_parameters, { role_ref = local.cluster_role_ref, subjects = local.subjects }, var.overrides)
  k8s_rbac_authorization_k8s_io_v1_role_parameters                 = merge(local.parameters, { rules = local.role_rules }, var.overrides)
  k8s_rbac_authorization_k8s_io_v1_role_binding_parameters         = merge(local.parameters, { role_ref = local.role_ref, subjects = local.subjects }, var.overrides)
}
