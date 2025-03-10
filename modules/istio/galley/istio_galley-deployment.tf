resource "k8s_apps_v1_deployment" "istio_galley" {
  metadata {
    labels = {
      "app"      = "galley"
      "chart"    = "galley"
      "heritage" = "Tiller"
      "istio"    = "galley"
      "release"  = "istio"
    }
    name      = "istio-galley"
    namespace = var.namespace
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        "istio" = "galley"
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
          "app"      = "galley"
          "chart"    = "galley"
          "heritage" = "Tiller"
          "istio"    = "galley"
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
          command = [
            "/usr/local/bin/galley",
            "server",
            "--meshConfigFile=/etc/mesh-config/mesh",
            "--livenessProbeInterval=1s",
            "--livenessProbePath=/tmp/healthliveness",
            "--readinessProbePath=/tmp/healthready",
            "--readinessProbeInterval=1s",
            "--deployment-namespace=${var.namespace}",
            "--insecure=true",
            "--enable-reconcileWebhookConfiguration=true",
            "--monitoringPort=15014",
            "--log_output_level=default:info",
          ]
          image             = "docker.io/istio/galley:1.5.2"
          image_pull_policy = "IfNotPresent"
          liveness_probe {
            exec {
              command = [
                "/usr/local/bin/galley",
                "probe",
                "--probe-path=/tmp/healthliveness",
                "--interval=10s",
              ]
            }
            initial_delay_seconds = 5
            period_seconds        = 5
          }
          name = "galley"

          ports {
            container_port = 9443
          }
          ports {
            container_port = 15014
          }
          ports {
            container_port = 9901
          }
          readiness_probe {
            exec {
              command = [
                "/usr/local/bin/galley",
                "probe",
                "--probe-path=/tmp/healthready",
                "--interval=10s",
              ]
            }
            initial_delay_seconds = 5
            period_seconds        = 5
          }
          resources {
            requests = {
              "cpu" = "10m"
            }
          }

          volume_mounts {
            mount_path = "/etc/certs"
            name       = "certs"
            read_only  = true
          }
          volume_mounts {
            mount_path = "/etc/config"
            name       = "config"
            read_only  = true
          }
          volume_mounts {
            mount_path = "/etc/mesh-config"
            name       = "mesh-config"
            read_only  = true
          }
        }
        service_account_name = "istio-galley-service-account"

        volumes {
          name = "certs"
          secret {
            secret_name = "istio.istio-galley-service-account"
          }
        }
        volumes {
          empty_dir {
            medium = "Memory"
          }
          name = "config"
        }
        volumes {
          config_map {
            name = "istio"
          }
          name = "mesh-config"
        }
      }
    }
  }
}