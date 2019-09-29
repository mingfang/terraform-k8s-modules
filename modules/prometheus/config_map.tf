resource "k8s_core_v1_config_map" "this" {
  data = {
    "prometheus.yml" = data.template_file.prometheus.rendered
  }

  metadata {
    name      = var.name
    namespace = var.namespace
  }
}

data "template_file" "prometheus" {
  template = "${file("${path.module}/prometheus-kubernetes.yml")}"
}
