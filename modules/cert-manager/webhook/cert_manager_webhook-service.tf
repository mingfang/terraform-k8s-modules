resource "k8s_core_v1_service" "cert_manager_webhook" {
  metadata {
    labels = {
      "app"                         = "webhook"
      "app.kubernetes.io/component" = "webhook"
      "app.kubernetes.io/instance"  = "cert-manager"
      "app.kubernetes.io/name"      = "webhook"
      "app.kubernetes.io/version"   = "v1.5.1"
    }
    name      = "cert-manager-webhook"
    namespace = var.namespace
  }
  spec {

    ports {
      name        = "https"
      port        = 443
      protocol    = "TCP"
      target_port = "10250"
    }
    selector = {
      "app.kubernetes.io/component" = "webhook"
      "app.kubernetes.io/instance"  = "cert-manager"
      "app.kubernetes.io/name"      = "webhook"
    }
    type = "ClusterIP"
  }
}