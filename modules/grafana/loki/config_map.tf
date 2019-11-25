resource "k8s_core_v1_config_map" "this" {
  data = {
    "local-config.yaml" = data.template_file.config.rendered
  }

  metadata {
    name      = var.name
    namespace = var.namespace
  }
}

data "template_file" "config" {
  vars = {
    cassandra = var.cassandra
  }
  template = file(coalesce(var.config_file, "${path.module}/config.yml"))
}
