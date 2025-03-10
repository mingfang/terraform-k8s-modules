resource "k8s_core_v1_service" "cert_manager" {
  metadata {
    labels = {
      "app"                         = "cert-manager"
      "app.kubernetes.io/component" = "controller"
      "app.kubernetes.io/instance"  = "cert-manager"
      "app.kubernetes.io/name"      = "cert-manager"
      "app.kubernetes.io/version"   = "v1.5.1"
    }
    name      = "cert-manager"
    namespace = var.namespace
  }
  spec {

    ports {
      name        = "tcp-prometheus-servicemonitor"
      port        = 9402
      protocol    = "TCP"
      target_port = "9402"
    }
    selector = {
      "app.kubernetes.io/component" = "controller"
      "app.kubernetes.io/instance"  = "cert-manager"
      "app.kubernetes.io/name"      = "cert-manager"
    }
    type = "ClusterIP"
  }
}