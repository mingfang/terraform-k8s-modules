resource "k8s_extensions_v1beta1_deployment" "istio-tracing" {
  metadata {
    labels = {
      "app"      = "jaeger"
      "chart"    = "tracing"
      "heritage" = "Tiller"
      "release"  = "istio"
    }
    name      = "istio-tracing"
    namespace = "${var.namespace}"
  }
  spec {
    template {
      metadata {
        annotations = {
          "prometheus.io/path"                         = "/jaeger/metrics"
          "prometheus.io/port"                         = "16686"
          "prometheus.io/scrape"                       = "true"
          "scheduler.alpha.kubernetes.io/critical-pod" = ""
          "sidecar.istio.io/inject"                    = "false"
        }
        labels = {
          "app"      = "jaeger"
          "chart"    = "tracing"
          "heritage" = "Tiller"
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
            name  = "COLLECTOR_ZIPKIN_HTTP_PORT"
            value = "9411"
          }
          env {
            name  = "MEMORY_MAX_TRACES"
            value = "50000"
          }
          env {
            name  = "QUERY_BASE_PATH"
            value = "/jaeger"
          }
          image             = "docker.io/jaegertracing/all-in-one:1.9"
          image_pull_policy = "IfNotPresent"
          liveness_probe {
            http_get {
              path = "/"
              port = "16686"
            }
          }
          name = "jaeger"

          ports {
            container_port = 9411
          }
          ports {
            container_port = 16686
          }
          ports {
            container_port = 5775
            protocol       = "UDP"
          }
          ports {
            container_port = 6831
            protocol       = "UDP"
          }
          ports {
            container_port = 6832
            protocol       = "UDP"
          }
          readiness_probe {
            http_get {
              path = "/"
              port = "16686"
            }
          }
          resources {
            requests = {
              "cpu" = "10m"
            }
          }
        }
      }
    }
  }
}