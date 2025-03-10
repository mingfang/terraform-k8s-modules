resource "k8s_apps_v1_deployment" "cert_manager_webhook" {
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
    replicas = 1
    selector {
      match_labels = {
        "app.kubernetes.io/component" = "webhook"
        "app.kubernetes.io/instance"  = "cert-manager"
        "app.kubernetes.io/name"      = "webhook"
      }
    }
    template {
      metadata {
        labels = {
          "app"                         = "webhook"
          "app.kubernetes.io/component" = "webhook"
          "app.kubernetes.io/instance"  = "cert-manager"
          "app.kubernetes.io/name"      = "webhook"
          "app.kubernetes.io/version"   = "v1.5.1"
        }
      }
      spec {

        containers {
          args = [
            "--v=2",
            "--secure-port=10250",
            "--dynamic-serving-ca-secret-namespace=$(POD_NAMESPACE)",
            "--dynamic-serving-ca-secret-name=cert-manager-webhook-ca",
            "--dynamic-serving-dns-names=cert-manager-webhook,cert-manager-webhook.cert-manager,cert-manager-webhook.cert-manager.svc",
          ]

          env {
            name = "POD_NAMESPACE"
            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }
          image             = "quay.io/jetstack/cert-manager-webhook:v1.5.1"
          image_pull_policy = "IfNotPresent"
          liveness_probe {
            failure_threshold = 3
            http_get {
              path   = "/livez"
              port   = "6080"
              scheme = "HTTP"
            }
            initial_delay_seconds = 60
            period_seconds        = 10
            success_threshold     = 1
            timeout_seconds       = 1
          }
          name = "cert-manager"

          ports {
            container_port = 10250
            name           = "https"
            protocol       = "TCP"
          }
          readiness_probe {
            failure_threshold = 3
            http_get {
              path   = "/healthz"
              port   = "6080"
              scheme = "HTTP"
            }
            initial_delay_seconds = 5
            period_seconds        = 5
            success_threshold     = 1
            timeout_seconds       = 1
          }
          resources {
          }
        }
        security_context {
          run_asnon_root = true
        }
        service_account_name = "cert-manager-webhook"
      }
    }
  }
}