module "rbac" {
  source    = "../rbac"
  name      = var.name
  namespace = var.namespace

  cluster_role_rules = var.cluster_role_rules
  role_rules         = var.role_rules
}

resource "k8s_rbac_authorization_k8s_io_v1_cluster_role_binding" "cluster_role_refs" {
  for_each = { for ref in var.cluster_role_refs : ref.name => ref }
  metadata {
    name = "${var.namespace}:${var.name}:${each.value.name}"
  }
  subjects {
    kind      = "ServiceAccount"
    name      = module.rbac.service_account_name
    namespace = var.namespace
  }
  role_ref {
    api_group = each.value.api_group
    kind      = each.value.kind
    name      = each.value.name

  }
}

resource "k8s_rbac_authorization_k8s_io_v1_role_binding" "role_refs" {
  for_each = { for ref in var.role_refs : ref.name => ref }
  metadata {
    name      = "${var.namespace}:${var.name}:${each.value.name}"
    namespace = var.namespace
  }
  subjects {
    kind      = "ServiceAccount"
    name      = module.rbac.service_account_name
    namespace = var.namespace
  }
  role_ref {
    api_group = each.value.api_group
    kind      = each.value.kind
    name      = each.value.name

  }
}

resource "k8s_core_v1_secret" "this" {
  metadata {
    name      = var.name
    namespace = var.namespace
    annotations = {
      "kubernetes.io/service-account.name" = module.rbac.service_account_name
    }
  }

  type = "kubernetes.io/service-account-token"
}
