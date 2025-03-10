resource "k8s_core_v1_config_map" "this" {
  data = {
    "logback.xml" = data.template_file.config.rendered
  }

  metadata {
    name      = var.name
    namespace = var.namespace
  }
}

data "template_file" "config" {
  template = file(coalesce(var.logback_xml_file, "${path.module}/logback.xml"))
}
