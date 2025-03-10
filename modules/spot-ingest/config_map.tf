resource "k8s_core_v1_config_map" "this" {
  metadata {
    labels    = "${local.labels}"
    name      = "${var.name}"
    namespace = "${var.namespace}"
  }

  data = {
    "spot.conf"        = "${data.template_file.spot.rendered}"
    "ingest_conf.json" = "${data.template_file.ingest_conf.rendered}"
    "core-site.xml"    = "${data.template_file.core_site.rendered}"
  }
}

data "template_file" "spot" {
  vars {
    dbengine = "hive"
  }

  template = "${file("${path.module}/templates/spot.conf")}"
}

data "template_file" "ingest_conf" {
  vars {
    kafka_server     = "${var.kafka_server}"
    kafka_port       = "${var.kafka_port}"
    zookeeper_server = "${var.zookeeper_server}"
    zookeeper_port   = "${var.zookeeper_port}"
  }

  template = "${file("${path.module}/templates/ingest_conf.json")}"
}

data "template_file" "core_site" {
  vars {
    namenode = "${var.namenode}"
  }

  template = "${file("${path.module}/templates/core-site.xml")}"
}
