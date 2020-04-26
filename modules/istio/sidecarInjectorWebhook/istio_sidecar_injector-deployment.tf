resource "k8s_apps_v1_deployment" "istio_sidecar_injector" {
  metadata {
    labels = {
      "app"      = "sidecarInjectorWebhook"
      "chart"    = "sidecarInjectorWebhook"
      "heritage" = "Tiller"
      "istio"    = "sidecar-injector"
      "release"  = "istio"
    }
    name      = "istio-sidecar-injector"
    namespace = var.namespace
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        "istio" = "sidecar-injector"
      }
    }
    strategy {
      rolling_update {
        max_surge       = "100%"
        max_unavailable = "25%"
      }
    }
    template {
      metadata {
        annotations = {
          "sidecar.istio.io/inject" = "false"
        }
        labels = {
          "app"      = "sidecarInjectorWebhook"
          "chart"    = "sidecarInjectorWebhook"
          "heritage" = "Tiller"
          "istio"    = "sidecar-injector"
          "release"  = "istio"
        }
      }
      spec {
        affinity {
          node_affinity {

            preferred_during_scheduling_ignored_during_execution {
              preference {

                match_expressions {
                  key      = "beta.kubernetes.io/arch"
                  operator = "In"
                  values = [
                    "amd64",
                  ]
                }
              }
              weight = 2
            }
            preferred_during_scheduling_ignored_during_execution {
              preference {

                match_expressions {
                  key      = "beta.kubernetes.io/arch"
                  operator = "In"
                  values = [
                    "ppc64le",
                  ]
                }
              }
              weight = 2
            }
            preferred_during_scheduling_ignored_during_execution {
              preference {

                match_expressions {
                  key      = "beta.kubernetes.io/arch"
                  operator = "In"
                  values = [
                    "s390x",
                  ]
                }
              }
              weight = 2
            }
            required_during_scheduling_ignored_during_execution {

              node_selector_terms {

                match_expressions {
                  key      = "beta.kubernetes.io/arch"
                  operator = "In"
                  values = [
                    "amd64",
                    "ppc64le",
                    "s390x",
                  ]
                }
              }
            }
          }
        }

        containers {
          args = [
            "--caCertFile=/etc/istio/certs/root-cert.pem",
            "--tlsCertFile=/etc/istio/certs/cert-chain.pem",
            "--tlsKeyFile=/etc/istio/certs/key.pem",
            "--injectConfig=/etc/istio/inject/config",
            "--meshConfig=/etc/istio/config/mesh",
            "--healthCheckInterval=2s",
            "--healthCheckFile=/tmp/health",
            "--reconcileWebhookConfig=true",
          ]
          image             = "docker.io/istio/sidecar_injector:1.5.2"
          image_pull_policy = "IfNotPresent"
          liveness_probe {
            exec {
              command = [
                "/usr/local/bin/sidecar-injector",
                "probe",
                "--probe-path=/tmp/health",
                "--interval=4s",
              ]
            }
            initial_delay_seconds = 4
            period_seconds        = 4
          }
          name = "sidecar-injector-webhook"
          readiness_probe {
            exec {
              command = [
                "/usr/local/bin/sidecar-injector",
                "probe",
                "--probe-path=/tmp/health",
                "--interval=4s",
              ]
            }
            initial_delay_seconds = 4
            period_seconds        = 4
          }
          resources {
            requests = {
              "cpu" = "10m"
            }
          }

          volume_mounts {
            mount_path = "/etc/istio/config"
            name       = "config-volume"
            read_only  = true
          }
          volume_mounts {
            mount_path = "/etc/istio/certs"
            name       = "certs"
            read_only  = true
          }
          volume_mounts {
            mount_path = "/etc/istio/inject"
            name       = "inject-config"
            read_only  = true
          }
        }
        service_account_name = "istio-sidecar-injector-service-account"

        volumes {
          config_map {
            name = "istio"
          }
          name = "config-volume"
        }
        volumes {
          name = "certs"
          secret {
            secret_name = "istio.istio-sidecar-injector-service-account"
          }
        }
        volumes {
          config_map {

            items {
              key  = "config"
              path = "config"
            }
            items {
              key  = "values"
              path = "values"
            }
            name = "istio-sidecar-injector"
          }
          name = "inject-config"
        }
      }
    }
  }
}