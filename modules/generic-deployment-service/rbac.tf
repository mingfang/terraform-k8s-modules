locals {
  use_RBAC = length(var.cluster_role_rules) + length(var.role_rules) + length(var.cluster_role_refs) > 0
}

module "rbac" {
  count     = local.use_RBAC ? 1 : 0
  source    = "../../modules/kubernetes/rbac"
  name      = var.name
  namespace = var.namespace

  cluster_role_rules = var.cluster_role_rules
  role_rules         = var.role_rules
}
