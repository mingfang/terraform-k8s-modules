/**
 * Documentation
 *
 * terraform-docs --sort-inputs-by-required --with-aggregate-type-defaults md
 *
 */

locals {
  labels = {
    app     = var.parameters.name
    name    = var.parameters.name
    service = var.parameters.name
  }

  selector = {
    match_labels = local.labels
  }

  k8s_core_v1_service_parameters      = merge({ labels = local.labels, selector = local.labels }, var.parameters)
  k8s_apps_v1_stateful_set_parameters = merge({ labels = local.labels, selector = local.selector, service_name = var.parameters.name }, var.parameters)
}
