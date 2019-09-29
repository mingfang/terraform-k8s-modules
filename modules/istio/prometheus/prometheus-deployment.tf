resource "k8s_extensions_v1beta1_deployment" "prometheus" {
  metadata {
    labels = {
      "app"      = "prometheus"
      "chart"    = "prometheus"
      "heritage" = "Tiller"
      "release"  = "istio"
    }
    name      = "prometheus"
    namespace = "${var.namespace}"
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        "app" = "prometheus"
      }
    }
    template {
      metadata {
        annotations = {
          "scheduler.alpha.kubernetes.io/critical-pod" = ""
          "sidecar.istio.io/inject"                    = "false"
        }
        labels = {
          "app"      = "prometheus"
          "chart"    = "prometheus"
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
          args = [
            "--storage.tsdb.retention=6h",
            "--config.file=/etc/prometheus/prometheus.yml",
          ]
          image             = "docker.io/prom/prometheus:v2.3.1"
          image_pull_policy = "IfNotPresent"
          liveness_probe {
            http_get {
              path = "/-/healthy"
              port = "9090"
            }
          }
          name = "prometheus"

          ports {
            container_port = 9090
            name           = "http"
          }
          readiness_probe {
            http_get {
              path = "/-/ready"
              port = "9090"
            }
          }
          resources {
            requests = {
              "cpu" = "10m"
            }
          }

          volume_mounts {
            mount_path = "/etc/prometheus"
            name       = "config-volume"
          }
          volume_mounts {
            mount_path = "/etc/istio-certs"
            name       = "istio-certs"
          }
        }

        init_containers {
          command = [
            "sh",
            "-c",
            <<-EOF
            counter=0; until [ "$counter" -ge 30 ]; do if [ -f /etc/istio-certs/key.pem ]; then exit 0; else echo waiting for istio certs && sleep 1 && counter=$((counter+1)); fi; done; exit 1;
            EOF
            ,
          ]
          image = "busybox:1.30.1"
          image_pull_policy = "IfNotPresent"
          name = "prom-init"

          volume_mounts {
            mount_path = "/etc/istio-certs"
            name = "istio-certs"
          }
        }
        service_account_name = "prometheus"

        volumes {
          config_map {
            name = "prometheus"
          }
          name = "config-volume"
        }
        volumes {
          name = "istio-certs"
          secret {
            default_mode = 420
            optional = true
            secret_name = "istio.default"
          }
        }
      }
    }
  }
}