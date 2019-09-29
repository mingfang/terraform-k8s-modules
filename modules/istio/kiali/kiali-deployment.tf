resource "k8s_extensions_v1beta1_deployment" "kiali" {
  metadata {
    labels = {
      "app"      = "kiali"
      "chart"    = "kiali"
      "heritage" = "Tiller"
      "release"  = "istio"
    }
    name      = "kiali"
    namespace = "${var.namespace}"
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
            "4",
          ]

          env {
            name = "ACTIVE_NAMESPACE"
            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }
          env {
            name = "SERVER_CREDENTIALS_USERNAME"
            value_from {
              secret_key_ref {
                key      = "username"
                name     = "kiali"
                optional = true
              }
            }
          }
          env {
            name = "SERVER_CREDENTIALS_PASSWORD"
            value_from {
              secret_key_ref {
                key      = "passphrase"
                name     = "kiali"
                optional = true
              }
            }
          }
          env {
            name  = "PROMETHEUS_SERVICE_URL"
            value = "http://prometheus:9090"
          }
          env {
            name  = "SERVER_WEB_ROOT"
            value = "/kiali"
          }
          image = "docker.io/kiali/kiali:v0.14"
          name  = "kiali"
          resources {
            requests = {
              "cpu" = "10m"
            }
          }

          volume_mounts {
            mount_path = "/kiali-configuration"
            name       = "kiali-configuration"
          }
        }
        service_account_name = "kiali-service-account"

        volumes {
          config_map {
            name = "kiali"
          }
          name = "kiali-configuration"
        }
      }
    }
  }
}