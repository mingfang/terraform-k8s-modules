resource "k8s_core_v1_config_map" "this" {
  data = {
    "graffiti-config.yaml" = data.template_file.config.rendered
  }

  metadata {
    name      = var.name
    namespace = var.namespace
  }
}

data "template_file" "config" {
  template = file("${path.module}/config.yml")
  vars = {
    log-level      = var.log_level
    check-existing = var.check_existing
    namespace      = var.namespace
    service        = var.name
    port           = 8443
    rules          = var.rules
  }
}
