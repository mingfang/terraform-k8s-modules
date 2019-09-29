//GENERATE DYNAMIC//k8s_rbac_authorization_k8s_io_v1_cluster_role//count = var.cluster_role_rules == null ? 0 : 1//
resource "k8s_rbac_authorization_k8s_io_v1_cluster_role" "this" {
  count = var.cluster_role_rules == null ? 0 : 1

  dynamic "aggregation_rule" {
    for_each = lookup(local.k8s_rbac_authorization_k8s_io_v1_cluster_role_parameters, "aggregation_rule", null) == null ? [] : [local.k8s_rbac_authorization_k8s_io_v1_cluster_role_parameters.aggregation_rule]
    content {
      dynamic "cluster_role_selectors" {
        for_each = lookup(aggregation_rule.value, "cluster_role_selectors", [])
        content {
          dynamic "match_expressions" {
            for_each = lookup(cluster_role_selectors.value, "match_expressions", [])
            content {
              key      = match_expressions.value.key
              operator = match_expressions.value.operator
              values   = contains(keys(match_expressions.value), "values") ? tolist(match_expressions.value.values) : null
            }
          }
          match_labels = lookup(cluster_role_selectors.value, "match_labels", null)
        }
      }
    }
  }

  metadata {
    annotations = lookup(local.k8s_rbac_authorization_k8s_io_v1_cluster_role_parameters, "annotations", null)
    labels      = lookup(local.k8s_rbac_authorization_k8s_io_v1_cluster_role_parameters, "labels", null)
    name        = lookup(local.k8s_rbac_authorization_k8s_io_v1_cluster_role_parameters, "name", null)
    namespace   = lookup(local.k8s_rbac_authorization_k8s_io_v1_cluster_role_parameters, "namespace", null)
  }

  dynamic "rules" {
    for_each = lookup(local.k8s_rbac_authorization_k8s_io_v1_cluster_role_parameters, "rules", [])
    content {
      api_groups        = contains(keys(rules.value), "api_groups") ? tolist(rules.value.api_groups) : null
      non_resource_urls = contains(keys(rules.value), "non_resource_urls") ? tolist(rules.value.non_resource_urls) : null
      resource_names    = contains(keys(rules.value), "resource_names") ? tolist(rules.value.resource_names) : null
      resources         = contains(keys(rules.value), "resources") ? tolist(rules.value.resources) : null
      verbs             = rules.value.verbs
    }
  }

  lifecycle {

  }
}

