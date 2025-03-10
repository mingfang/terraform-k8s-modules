resource "k8s_core_v1_config_map" "this" {
  data = yamldecode(data.template_file.config.rendered)

  metadata {
    name      = var.name
    namespace = var.namespace
  }
}

data "template_file" "config" {
  template = file("${path.module}/config.yml")
}
