module "config" {
  source    = "../../kubernetes/config-map"
  name      = var.name
  namespace = var.namespace
  from-dir  = "${path.module}/etc-sentry"
}