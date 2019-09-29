resource "k8s_core_v1_config_map" "this" {
  metadata {
    labels    = "${local.labels}"
    name      = "${var.name}"
    namespace = "${var.namespace}"
  }

  data {
    "storm.yaml" = "${data.template_file.storm.rendered}"
  }
}

data "template_file" "storm" {
  vars {
    storm_zookeeper_servers = "${join(",", formatlist("\"%s\"", var.storm_zookeeper_servers))}"
    nimbus_seeds            = "${join(",", formatlist("\"%s\"", var.nimbus_seeds))}"
    supervisor_slots_ports  = "${join(",", data.template_file.ports.*.rendered)}"
  }

  template = "${file("${path.module}/storm.yaml")}"
}

data "template_file" "ports" {
  count    = "${length(var.supervisor_slots_ports)}"
  template = "${lookup(var.supervisor_slots_ports[count.index], "port")}"
}
