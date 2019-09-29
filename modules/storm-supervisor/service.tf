resource "k8s_core_v1_service" "this" {
  metadata {
    annotations = "${var.annotations}"
    labels      = "${local.labels}"
    name        = "${var.name}"
    namespace   = "${var.namespace}"
  }

  spec {
    ports = ["${var.supervisor_slots_ports}"]

    selector         = "${local.labels}"
    session_affinity = "${var.session_affinity}"
    type             = "${var.service_type}"
  }
}
