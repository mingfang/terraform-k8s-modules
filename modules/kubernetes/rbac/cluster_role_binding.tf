//GENERATE DYNAMIC//k8s_rbac_authorization_k8s_io_v1_cluster_role_binding//count = var.cluster_role_rules == null ? 0 : 1//
resource "k8s_rbac_authorization_k8s_io_v1_cluster_role_binding" "this" {
  count = var.cluster_role_rules == null ? 0 : 1

  metadata {
    annotations = lookup(local.k8s_rbac_authorization_k8s_io_v1_cluster_role_binding_parameters, "annotations", null)
    labels      = lookup(local.k8s_rbac_authorization_k8s_io_v1_cluster_role_binding_parameters, "labels", null)
    name        = lookup(local.k8s_rbac_authorization_k8s_io_v1_cluster_role_binding_parameters, "name", null)
    namespace   = lookup(local.k8s_rbac_authorization_k8s_io_v1_cluster_role_binding_parameters, "namespace", null)
  }

  dynamic "role_ref" {
    for_each = lookup(local.k8s_rbac_authorization_k8s_io_v1_cluster_role_binding_parameters, "role_ref", null) == null ? [] : [local.k8s_rbac_authorization_k8s_io_v1_cluster_role_binding_parameters.role_ref]
    content {
      api_group = role_ref.value.api_group
      kind      = role_ref.value.kind
      name      = role_ref.value.name
    }
  }

  dynamic "subjects" {
    for_each = lookup(local.k8s_rbac_authorization_k8s_io_v1_cluster_role_binding_parameters, "subjects", [])
    content {
      api_group = lookup(subjects.value, "api_group", null)
      kind      = subjects.value.kind
      name      = subjects.value.name
      namespace = lookup(subjects.value, "namespace", null)
    }
  }

  lifecycle {

  }
}

