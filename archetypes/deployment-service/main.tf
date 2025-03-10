locals {
  labels = lookup(var.parameters, "labels", {
    app     = var.parameters.name
    name    = var.parameters.name
    service = var.parameters.name
  })

  selector = {
    match_labels = local.labels
  }

  podAnnotations = merge(coalesce(lookup(var.parameters, "annotations", {}), {}), var.podAnnotations)

  k8s_core_v1_service_parameters = merge(
    var.parameters,
    { labels = local.labels, selector = local.labels },
  )

  k8s_apps_v1_deployment_parameters = merge(
    var.parameters,
    { labels = local.labels, selector = local.selector, annotations = local.podAnnotations },
  )

  enable_service = length(lookup(var.parameters, "ports", [])) > 0
}
