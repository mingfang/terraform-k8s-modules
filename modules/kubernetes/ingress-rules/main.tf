locals {
  labels = {
    app     = var.name
    name    = var.name
    service = var.name
  }

  parameters = {
    name        = var.name
    namespace   = var.namespace
    labels      = local.labels
    annotations = merge({ "kubernetes.io/ingress.class" = var.ingress_class }, var.annotations)
    rules       = var.rules == null ? [] : var.rules
    tls         = var.tls == null ? [] : var.tls
  }

  k8s_extensions_v1beta1_ingress_parameters = merge(local.parameters, var.overrides)
}