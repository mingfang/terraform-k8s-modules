resource "k8s_apps_v1_deployment" "istio_pilot" {
  metadata {
    labels = {
      "app"      = "pilot"
      "chart"    = "pilot"
      "heritage" = "Tiller"
      "istio"    = "pilot"
      "release"  = "istio"
    }
    name      = "istio-pilot"
    namespace = var.namespace
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        "istio" = "pilot"
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
          "app"      = "pilot"
          "chart"    = "pilot"
          "heritage" = "Tiller"
          "istio"    = "pilot"
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
            "discovery",
            "--monitoringAddr=:15014",
            "--log_output_level=default:info",
            "--domain",
            "cluster.local",
            "--secureGrpcAddr",
            "",
            "--keepaliveMaxServerConnectionAge",
            "30m",
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
            name  = "PILOT_PUSH_THROTTLE"
            value = "100"
          }
          env {
            name  = "PILOT_TRACE_SAMPLING"
            value = "100"
          }
          env {
            name  = "PILOT_ENABLE_PROTOCOL_SNIFFING_FOR_OUTBOUND"
            value = "true"
          }
          env {
            name  = "PILOT_ENABLE_PROTOCOL_SNIFFING_FOR_INBOUND"
            value = "false"
          }
          image             = "docker.io/istio/pilot:1.5.2"
          image_pull_policy = "IfNotPresent"
          name              = "discovery"

          ports {
            container_port = 8080
          }
          ports {
            container_port = 15010
          }
          readiness_probe {
            http_get {
              path = "/ready"
              port = "8080"
            }
            initial_delay_seconds = 5
            period_seconds        = 5
            timeout_seconds       = 5
          }
          resources {
            requests = {
              "cpu"    = "10m"
              "memory" = "100Mi"
            }
          }

          volume_mounts {
            mount_path = "/etc/istio/config"
            name       = "config-volume"
          }
          volume_mounts {
            mount_path = "/etc/certs"
            name       = "istio-certs"
            read_only  = true
          }
        }
        containers {
          args = [
            "proxy",
            "--domain",
            "$(POD_NAMESPACE).svc.cluster.local",
            "--serviceCluster",
            "istio-pilot",
            "--templateFile",
            "/etc/istio/proxy/envoy_pilot.yaml.tmpl",
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
            container_port = 15003
          }
          ports {
            container_port = 15005
          }
          ports {
            container_port = 15007
          }
          ports {
            container_port = 15011
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
        }
        service_account_name = "istio-pilot-service-account"

        volumes {
          config_map {
            name = "istio"
          }
          name = "config-volume"
        }
        volumes {
          name = "istio-certs"
          secret {
            optional    = true
            secret_name = "istio.istio-pilot-service-account"
          }
        }
      }
    }
  }
}