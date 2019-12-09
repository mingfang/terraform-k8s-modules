resource "k8s_core_v1_service" "ingress-nginx" {
  metadata {
    labels = {
      "app.kubernetes.io/name"    = var.name
      "app.kubernetes.io/part-of" = var.name
    }
    name      = var.name
    namespace = var.namespace
  }
  spec {
    load_balancer_ip = var.load_balancer_ip

    dynamic "ports" {
      for_each = var.ports == null ? [] : var.ports
      content {
        name        = lookup(ports.value, "name", null)
        node_port   = lookup(ports.value, "node_port", null)
        port        = ports.value.port
        protocol    = lookup(ports.value, "protocol", null)
        target_port = lookup(ports.value, "target_port", null)
      }
    }
    dynamic "ports" {
      for_each = var.tcp_services_data
      content {
        name        = "tcp-${ports.key}"
        port        = ports.key
        protocol    = "TCP"
        target_port = split(":", ports.value)[1]
      }
    }
    dynamic "ports" {
      for_each = var.udp_services_data
      content {
        name        = "udp-${ports.key}"
        port        = ports.key
        protocol    = "UDP"
        target_port = split(":", ports.value)[1]
      }
    }

    selector = {
      "app.kubernetes.io/name"    = var.name
      "app.kubernetes.io/part-of" = var.name
    }
    type = var.service_type
  }
}