resource "k8s_core_v1_config_map" "this" {
  data = {
    "datasources.yaml" = data.template_file.datasources_file.rendered
    "dashboards.yaml"  = data.template_file.dashboards_file.rendered
  }

  metadata {
    name      = var.name
    namespace = var.namespace
  }
}

data "template_file" "datasources_file" {
  template = file(coalesce(var.datasources_file, "${path.module}/datasources.yaml"))
}

data "template_file" "dashboards_file" {
  template = file(coalesce(var.dashboards_file, "${path.module}/dashboards.yaml"))
}
