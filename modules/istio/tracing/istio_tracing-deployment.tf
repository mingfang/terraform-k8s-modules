resource "k8s_apps_v1_deployment" "istio_tracing" {
  metadata {
    labels = {
      "app"      = "jaeger"
      "chart"    = "tracing"
      "heritage" = "Tiller"
      "release"  = "istio"
    }
    name      = "istio-tracing"
    namespace = var.namespace
  }
  spec {
    selector {
      match_labels = {
        "app" = "jaeger"
      }
    }
    template {
      metadata {
        annotations = {
          "prometheus.io/port"      = "14269"
          "prometheus.io/scrape"    = "true"
          "sidecar.istio.io/inject" = "false"
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
            name  = "BADGER_EPHEMERAL"
            value = "false"
          }
          env {
            name  = "SPAN_STORAGE_TYPE"
            value = "badger"
          }
          env {
            name  = "BADGER_DIRECTORY_VALUE"
            value = "/badger/data"
          }
          env {
            name  = "BADGER_DIRECTORY_KEY"
            value = "/badger/key"
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
          image             = "docker.io/jaegertracing/all-in-one:1.16"
          image_pull_policy = "IfNotPresent"
          liveness_probe {
            http_get {
              path = "/"
              port = "14269"
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
            container_port = 14250
          }
          ports {
            container_port = 14267
          }
          ports {
            container_port = 14268
          }
          ports {
            container_port = 14269
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
              port = "14269"
            }
          }
          resources {
            requests = {
              "cpu" = "10m"
            }
          }

          volume_mounts {
            mount_path = "/badger"
            name       = "data"
          }
        }

        volumes {
          empty_dir {
          }
          name = "data"
        }
      }
    }
  }
}