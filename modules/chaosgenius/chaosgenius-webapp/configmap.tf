module "config" {
  source = "../../kubernetes/config-map"
  name = var.name
  namespace = var.namespace

  from-file = "${path.module}/default.conf"
}