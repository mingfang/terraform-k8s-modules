resource "k8s_apps_v1_deployment" "kiali" {
  metadata {
    labels = {
      "app"      = "kiali"
      "chart"    = "kiali"
      "heritage" = "Tiller"
      "release"  = "istio"
    }
    name      = "kiali"
    namespace = var.namespace
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        "app" = "kiali"
      }
    }
    template {
      metadata {
        annotations = {
          "kiali.io/runtimes"                          = "go,kiali"
          "prometheus.io/port"                         = "9090"
          "prometheus.io/scrape"                       = "true"
          "scheduler.alpha.kubernetes.io/critical-pod" = ""
          "sidecar.istio.io/inject"                    = "false"
        }
        labels = {
          "app"      = "kiali"
          "chart"    = "kiali"
          "heritage" = "Tiller"
          "release"  = "istio"
        }
        name = "kiali"
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
            "/opt/kiali/kiali",
            "-config",
            "/kiali-configuration/config.yaml",
            "-v",
            "3",
          ]

          env {
            name = "ACTIVE_NAMESPACE"
            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }
          image             = "quay.io/kiali/kiali:v1.17"
          image_pull_policy = "IfNotPresent"
          liveness_probe {
            http_get {
              path   = "/kiali/healthz"
              port   = "20001"
              scheme = "HTTP"
            }
            initial_delay_seconds = 5
            period_seconds        = 30
          }
          name = "kiali"
          readiness_probe {
            http_get {
              path   = "/kiali/healthz"
              port   = "20001"
              scheme = "HTTP"
            }
            initial_delay_seconds = 5
            period_seconds        = 30
          }
          resources {
            requests = {
              "cpu" = "10m"
            }
          }

          volume_mounts {
            mount_path = "/kiali-configuration"
            name       = "kiali-configuration"
          }
          volume_mounts {
            mount_path = "/kiali-cert"
            name       = "kiali-cert"
          }
          volume_mounts {
            mount_path = "/kiali-secret"
            name       = "kiali-secret"
          }
        }
        service_account_name = "kiali-service-account"

        volumes {
          config_map {
            name = "kiali"
          }
          name = "kiali-configuration"
        }
        volumes {
          name = "kiali-cert"
          secret {
            optional    = true
            secret_name = "istio.kiali-service-account"
          }
        }
        volumes {
          name = "kiali-secret"
          secret {
            optional    = true
            secret_name = "kiali"
          }
        }
      }
    }
  }
}