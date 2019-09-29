resource "k8s_core_v1_config_map" "this" {
  data {
    "storm.yaml" = "${data.template_file.storm.rendered}"
  }

  metadata {
    labels    = "${local.labels}"
    name      = "${var.name}"
    namespace = "${var.namespace}"
  }
}

data "template_file" "storm" {
  vars {
    storm_zookeeper_servers = "${join(",", formatlist("\"%s\"", var.storm_zookeeper_servers))}"
  }

  template = "${file("${path.module}/storm.yaml")}"
}
