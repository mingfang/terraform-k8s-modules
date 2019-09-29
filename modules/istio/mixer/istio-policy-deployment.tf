resource "k8s_extensions_v1beta1_deployment" "istio-policy" {
  metadata {
    labels = {
      "app"      = "istio-mixer"
      "chart"    = "mixer"
      "heritage" = "Tiller"
      "istio"    = "mixer"
      "release"  = "istio"
    }
    name      = "istio-policy"
    namespace = "${var.namespace}"
  }
  spec {
    selector {
      match_labels = {
        "istio"            = "mixer"
        "istio-mixer-type" = "policy"
      }
    }
    strategy {
      rolling_update {
        max_surge       = "1"
        max_unavailable = "0"
      }
    }
    template {
      metadata {
        annotations = {
          "scheduler.alpha.kubernetes.io/critical-pod" = ""
          "sidecar.istio.io/inject"                    = "false"
        }
        labels = {
          "app"              = "policy"
          "chart"            = "mixer"
          "heritage"         = "Tiller"
          "istio"            = "mixer"
          "istio-mixer-type" = "policy"
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
            "--configStoreURL=mcp://istio-galley.${var.namespace}.svc:9901",
            "--configDefaultNamespace=${var.namespace}",
            "--useAdapterCRDs=true",
            "--trace_zipkin_url=http://zipkin:9411/api/v1/spans",
          ]

          env {
            name  = "GODEBUG"
            value = "gctrace=1"
          }
          env {
            name  = "GOMAXPROCS"
            value = "6"
          }
          image             = "docker.io/istio/mixer:1.1.2"
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
              "cpu"    = "100m"
              "memory" = "100Mi"
            }
            requests = {
              "cpu"    = "10m"
              "memory" = "100Mi"
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
        containers {
          args = [
            "proxy",
            "--domain",
            "$(POD_NAMESPACE).svc.cluster.local",
            "--serviceCluster",
            "istio-policy",
            "--templateFile",
            "/etc/istio/proxy/envoy_policy.yaml.tmpl",
            "--controlPlaneAuthPolicy",
            "NONE",
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
          image             = "docker.io/istio/proxyv2:1.1.2"
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
              "memory" = "128Mi"
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
          volume_mounts {
            mount_path = "/var/run/secrets/istio.io/policy/adapter"
            name       = "policy-adapter-secret"
            read_only  = true
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
          name = "policy-adapter-secret"
          secret {
            optional    = true
            secret_name = "policy-adapter-secret"
          }
        }
      }
    }
  }
}