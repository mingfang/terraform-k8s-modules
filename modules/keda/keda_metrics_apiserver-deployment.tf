resource "k8s_apps_v1_deployment" "keda_metrics_apiserver" {
  metadata {
    labels = {
      "app"                       = "keda-metrics-apiserver"
      "app.kubernetes.io/name"    = "keda-metrics-apiserver"
      "app.kubernetes.io/part-of" = "keda-operator"
      "app.kubernetes.io/version" = "2.14.0"
    }
    name      = "keda-metrics-apiserver"
    namespace = k8s_core_v1_namespace.keda.metadata.0.name
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        "app" = "keda-metrics-apiserver"
      }
    }
    template {
      metadata {
        labels = {
          "app" = "keda-metrics-apiserver"
        }
        name = "keda-metrics-apiserver"
      }
      spec {

        containers {
          args = [
            "/usr/local/bin/keda-adapter",
            "--secure-port=6443",
            "--logtostderr=true",
            "--stderrthreshold=ERROR",
            "--v=0",
            "--client-ca-file=/certs/ca.crt",
            "--tls-cert-file=/certs/tls.crt",
            "--tls-private-key-file=/certs/tls.key",
            "--cert-dir=/certs",
          ]

          env {
            name  = "WATCH_NAMESPACE"
            value = ""
          }
          env {
            name = "POD_NAMESPACE"
            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }
          env {
            name  = "KEDA_HTTP_DEFAULT_TIMEOUT"
            value = ""
          }
          image             = "ghcr.io/kedacore/keda-metrics-apiserver:2.14.0"
          image_pull_policy = "Always"
          liveness_probe {
            http_get {
              path   = "/healthz"
              port   = "6443"
              scheme = "HTTPS"
            }
            initial_delay_seconds = 5
          }
          name = "keda-metrics-apiserver"

          ports {
            container_port = 6443
            name           = "https"
          }
          ports {
            container_port = 8080
            name           = "http"
          }
          readiness_probe {
            http_get {
              path   = "/readyz"
              port   = "6443"
              scheme = "HTTPS"
            }
            initial_delay_seconds = 5
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
            mount_path = "/tmp"
            name       = "temp-vol"
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
        service_account_name = "keda-operator"

        volumes {
          empty_dir {
          }
          name = "temp-vol"
        }
        volumes {
          name = "certificates"
          secret {
            default_mode = 420
            secret_name  = "kedaorg-certs"
          }
        }
      }
    }
  }
}