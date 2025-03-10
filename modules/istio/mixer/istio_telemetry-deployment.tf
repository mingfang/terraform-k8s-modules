resource "k8s_apps_v1_deployment" "istio_telemetry" {
  metadata {
    labels = {
      "app"      = "istio-mixer"
      "chart"    = "mixer"
      "heritage" = "Tiller"
      "istio"    = "mixer"
      "release"  = "istio"
    }
    name      = "istio-telemetry"
    namespace = var.namespace
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        "istio"            = "mixer"
        "istio-mixer-type" = "telemetry"
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
          "app"              = "telemetry"
          "chart"            = "mixer"
          "heritage"         = "Tiller"
          "istio"            = "mixer"
          "istio-mixer-type" = "telemetry"
          "release"          = "istio"
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
            "--monitoringPort=15014",
            "--address",
            "unix:///sock/mixer.socket",
            "--log_output_level=default:info",
            "--configStoreURL=mcp://istio-galley.${var.namespace}.svc:9901",
            "--configDefaultNamespace=${var.namespace}",
            "--useAdapterCRDs=false",
            "--useTemplateCRDs=false",
            "--trace_zipkin_url=http://zipkin.${var.namespace}:9411/api/v1/spans",
            "--averageLatencyThreshold",
            "100ms",
            "--loadsheddingMode",
            "enforce",
          ]

          env {
            name = "POD_NAMESPACE"
            value_from {
              field_ref {
                api_version = "v1"
                field_path  = "metadata.namespace"
              }
            }
          }
          env {
            name  = "GOMAXPROCS"
            value = "6"
          }
          image             = "docker.io/istio/mixer:1.5.2"
          image_pull_policy = "IfNotPresent"
          liveness_probe {
            http_get {
              path = "/version"
              port = "15014"
            }
            initial_delay_seconds = 5
            period_seconds        = 5
          }
          name = "mixer"

          ports {
            container_port = 15014
          }
          ports {
            container_port = 42422
          }
          resources {
            limits = {
              "cpu"    = "4800m"
              "memory" = "4G"
            }
            requests = {
              "cpu"    = "50m"
              "memory" = "100Mi"
            }
          }

          volume_mounts {
            mount_path = "/etc/certs"
            name       = "istio-certs"
            read_only  = true
          }
          volume_mounts {
            mount_path = "/var/run/secrets/istio.io/telemetry/adapter"
            name       = "telemetry-adapter-secret"
            read_only  = true
          }
          volume_mounts {
            mount_path = "/sock"
            name       = "uds-socket"
          }
        }
        containers {
          args = [
            "proxy",
            "--domain",
            "$(POD_NAMESPACE).svc.cluster.local",
            "--serviceCluster",
            "istio-telemetry",
            "--templateFile",
            "/etc/istio/proxy/envoy_telemetry.yaml.tmpl",
            "--controlPlaneAuthPolicy",
            "NONE",
            "--log_output_level=default:info",
          ]

          env {
            name = "POD_NAME"
            value_from {
              field_ref {
                api_version = "v1"
                field_path  = "metadata.name"
              }
            }
          }
          env {
            name = "POD_NAMESPACE"
            value_from {
              field_ref {
                api_version = "v1"
                field_path  = "metadata.namespace"
              }
            }
          }
          env {
            name = "INSTANCE_IP"
            value_from {
              field_ref {
                api_version = "v1"
                field_path  = "status.podIP"
              }
            }
          }
          env {
            name  = "SDS_ENABLED"
            value = "false"
          }
          image             = "docker.io/istio/proxyv2:1.5.2"
          image_pull_policy = "IfNotPresent"
          name              = "istio-proxy"

          ports {
            container_port = 9091
          }
          ports {
            container_port = 15004
          }
          ports {
            container_port = 15090
            name           = "http-envoy-prom"
            protocol       = "TCP"
          }
          resources {
            limits = {
              "cpu"    = "2"
              "memory" = "1Gi"
            }
            requests = {
              "cpu"    = "10m"
              "memory" = "40Mi"
            }
          }

          volume_mounts {
            mount_path = "/etc/certs"
            name       = "istio-certs"
            read_only  = true
          }
          volume_mounts {
            mount_path = "/sock"
            name       = "uds-socket"
          }
        }
        service_account_name = "istio-mixer-service-account"

        volumes {
          name = "istio-certs"
          secret {
            optional    = true
            secret_name = "istio.istio-mixer-service-account"
          }
        }
        volumes {
          empty_dir {
          }
          name = "uds-socket"
        }
        volumes {
          name = "telemetry-adapter-secret"
          secret {
            optional    = true
            secret_name = "telemetry-adapter-secret"
          }
        }
      }
    }
  }
}