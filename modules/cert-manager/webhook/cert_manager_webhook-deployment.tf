resource "k8s_apps_v1_deployment" "cert_manager_webhook" {
  metadata {
    labels = {
      "app"                          = "webhook"
      "app.kubernetes.io/instance"   = "cert-manager"
      "app.kubernetes.io/managed-by" = "Tiller"
      "app.kubernetes.io/name"       = "webhook"
      "helm.sh/chart"                = "cert-manager-v0.12.0"
    }
    name      = "cert-manager-webhook"
    namespace = var.namespace
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        "app"                          = "webhook"
        "app.kubernetes.io/instance"   = "cert-manager"
        "app.kubernetes.io/managed-by" = "Tiller"
        "app.kubernetes.io/name"       = "webhook"
      }
    }
    template {
      metadata {
        labels = {
          "app"                          = "webhook"
          "app.kubernetes.io/instance"   = "cert-manager"
          "app.kubernetes.io/managed-by" = "Tiller"
          "app.kubernetes.io/name"       = "webhook"
          "helm.sh/chart"                = "cert-manager-v0.12.0"
        }
      }
      spec {

        containers {
          args = [
            "--v=2",
            "--secure-port=10250",
            "--tls-cert-file=/certs/tls.crt",
            "--tls-private-key-file=/certs/tls.key",
          ]

          env {
            name = "POD_NAMESPACE"
            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }
          image             = "quay.io/jetstack/cert-manager-webhook:v0.12.0"
          image_pull_policy = "IfNotPresent"
          liveness_probe {
            http_get {
              path   = "/livez"
              port   = "6080"
              scheme = "HTTP"
            }
          }
          name = "cert-manager"
          readiness_probe {
            http_get {
              path   = "/healthz"
              port   = "6080"
              scheme = "HTTP"
            }
          }
          resources {
          }

          volume_mounts {
            mount_path = "/certs"
            name       = "certs"
          }
        }
        service_account_name = "cert-manager-webhook"

        volumes {
          name = "certs"
          secret {
            secret_name = "cert-manager-webhook-tls"
          }
        }
      }
    }
  }
}