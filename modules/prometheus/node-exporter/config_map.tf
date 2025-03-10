resource "k8s_core_v1_config_map" "this" {
  data = {
    "promtail.yaml" = data.template_file.config.rendered
  }

  metadata {
    name      = var.name
    namespace = var.namespace
  }
}

data "template_file" "config" {
  template = file(coalesce(var.config_file, "${path.module}/promtail.yaml"))
}
