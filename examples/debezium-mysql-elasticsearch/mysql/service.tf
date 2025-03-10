resource "k8s_core_v1_service" "this" {
  metadata {
    name        = "${var.name}"
    namespace   = "${var.namespace}"
    labels      = "${local.labels}"
    annotations = "${var.annotations}"
  }

  spec {
    ports {
      name = "tcp"
      port = "${var.port}"
    }


    selector = "${local.labels}"
  }
}
