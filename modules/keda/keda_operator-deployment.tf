resource "k8s_apps_v1_deployment" "keda_operator" {
  metadata {
    labels = {
      "app"                         = "keda-operator"
      "app.kubernetes.io/component" = "operator"
      "app.kubernetes.io/name"      = "keda-operator"
      "app.kubernetes.io/part-of"   = "keda-operator"
      "app.kubernetes.io/version"   = "2.14.0"
    }
    name      = "keda-operator"
    namespace = k8s_core_v1_namespace.keda.metadata.0.name
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        "app" = "keda-operator"
      }
    }
    template {
      metadata {
        labels = {
          "app"  = "keda-operator"
          "name" = "keda-operator"
        }
        name = "keda-operator"
      }
      spec {

        containers {
          args = [
            "--leader-elect",
            "--zap-log-level=info",
            "--zap-encoder=console",
            "--zap-time-encoding=rfc3339",
            "--enable-cert-rotation=true",
          ]
          command = [
            "/keda",
          ]

          env {
            name = "POD_NAMESPACE"
            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }
          env {
            name  = "WATCH_NAMESPACE"
            value = ""
          }
          env {
            name  = "KEDA_HTTP_DEFAULT_TIMEOUT"
            value = ""
          }
          image             = "ghcr.io/kedacore/keda:2.14.0"
          image_pull_policy = "Always"
          liveness_probe {
            http_get {
              path = "/healthz"
              port = "8081"
            }
            initial_delay_seconds = 25
          }
          name = "keda-operator"

          ports {
            container_port = 8080
            name           = "http"
            protocol       = "TCP"
          }
          readiness_probe {
            http_get {
              path = "/readyz"
              port = "8081"
            }
            initial_delay_seconds = 20
          }
          resources {
            limits = {
              "cpu"    = "1000m"
              "memory" = "1000Mi"
            }
            requests = {
              "cpu"    = "100m"
              "memory" = "100Mi"
            }
          }
          security_context {
            allow_privilege_escalation = false
            capabilities {
              drop = [
                "ALL",
              ]
            }
            read_only_root_filesystem = true
            run_asnon_root            = true
            seccomp_profile {
              type = "RuntimeDefault"
            }
          }

          volume_mounts {
            mount_path = "/certs"
            name       = "certificates"
            read_only  = true
          }
        }
        node_selector = {
          "kubernetes.io/os" = "linux"
        }
        security_context {
          run_asnon_root = true
        }
        service_account_name             = "keda-operator"
        termination_grace_period_seconds = 10

        volumes {
          name = "certificates"
          secret {
            default_mode = 420
            optional     = true
            secret_name  = "kedaorg-certs"
          }
        }
      }
    }
  }
}