resource "k8s_extensions_v1beta1_deployment" "istio-ingressgateway" {
  metadata {
    labels = {
      "app"      = "istio-ingressgateway"
      "chart"    = "gateways"
      "heritage" = "Tiller"
      "istio"    = "ingressgateway"
      "release"  = "istio"
    }
    name      = "istio-ingressgateway"
    namespace = "${var.namespace}"
  }
  spec {
    template {
      metadata {
        annotations = {
          "scheduler.alpha.kubernetes.io/critical-pod" = ""
          "sidecar.istio.io/inject"                    = "false"
        }
        labels = {
          "app"      = "istio-ingressgateway"
          "chart"    = "gateways"
          "heritage" = "Tiller"
          "istio"    = "ingressgateway"
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
            "proxy",
            "router",
            "--domain",
            "$(POD_NAMESPACE).svc.cluster.local",
            "--log_output_level",
            "info",
            "--drainDuration",
            "45s",
            "--parentShutdownDuration",
            "1m0s",
            "--connectTimeout",
            "10s",
            "--serviceCluster",
            "istio-ingressgateway",
            "--zipkinAddress",
            "zipkin:9411",
            "--proxyAdminPort",
            "15000",
            "--statusPort",
            "15020",
            "--controlPlaneAuthPolicy",
            "NONE",
            "--discoveryAddress",
            "istio-pilot:15010",
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
            name = "ISTIO_META_POD_NAME"
            value_from {
              field_ref {
                api_version = "v1"
                field_path  = "metadata.name"
              }
            }
          }
          env {
            name = "ISTIO_META_CONFIG_NAMESPACE"
            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }
          env {
            name  = "ISTIO_META_ROUTER_MODE"
            value = "sni-dnat"
          }
          image             = "docker.io/istio/proxyv2:1.1.2"
          image_pull_policy = "IfNotPresent"
          name              = "istio-proxy"

          ports {
            container_port = 80
          }
          ports {
            container_port = 443
          }
          ports {
            container_port = 31400
          }
          ports {
            container_port = 15029
          }
          ports {
            container_port = 15030
          }
          ports {
            container_port = 15031
          }
          ports {
            container_port = 15032
          }
          ports {
            container_port = 15443
          }
          ports {
            container_port = 15020
          }
          ports {
            container_port = 15090
            name           = "http-envoy-prom"
            protocol       = "TCP"
          }
          readiness_probe {
            failure_threshold = 30
            http_get {
              path   = "/healthz/ready"
              port   = "15020"
              scheme = "HTTP"
            }
            initial_delay_seconds = 1
            period_seconds        = 2
            success_threshold     = 1
            timeout_seconds       = 1
          }
          resources {
            requests = {
              "cpu" = "10m"
            }
          }

          volume_mounts {
            mount_path = "/etc/certs"
            name       = "istio-certs"
            read_only  = true
          }
          volume_mounts {
            mount_path = "/etc/istio/ingressgateway-certs"
            name       = "ingressgateway-certs"
            read_only  = true
          }
          volume_mounts {
            mount_path = "/etc/istio/ingressgateway-ca-certs"
            name       = "ingressgateway-ca-certs"
            read_only  = true
          }
        }
        service_account_name = "istio-ingressgateway-service-account"

        volumes {
          name = "istio-certs"
          secret {
            optional    = true
            secret_name = "istio.istio-ingressgateway-service-account"
          }
        }
        volumes {
          name = "ingressgateway-certs"
          secret {
            optional    = true
            secret_name = "istio-ingressgateway-certs"
          }
        }
        volumes {
          name = "ingressgateway-ca-certs"
          secret {
            optional    = true
            secret_name = "istio-ingressgateway-ca-certs"
          }
        }
      }
    }
  }
}