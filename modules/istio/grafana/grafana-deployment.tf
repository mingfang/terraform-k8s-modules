resource "k8s_extensions_v1beta1_deployment" "grafana" {
  metadata {
    labels = {
      "app"      = "grafana"
      "chart"    = "grafana"
      "heritage" = "Tiller"
      "release"  = "istio"
    }
    name      = "grafana"
    namespace = "${var.namespace}"
  }
  spec {
    replicas = 1
    template {
      metadata {
        annotations = {
          "scheduler.alpha.kubernetes.io/critical-pod" = ""
          "sidecar.istio.io/inject"                    = "false"
        }
        labels = {
          "app"      = "grafana"
          "chart"    = "grafana"
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
            name  = "GRAFANA_PORT"
            value = "3000"
          }
          env {
            name  = "GF_AUTH_BASIC_ENABLED"
            value = "false"
          }
          env {
            name  = "GF_AUTH_ANONYMOUS_ENABLED"
            value = "true"
          }
          env {
            name  = "GF_AUTH_ANONYMOUS_ORG_ROLE"
            value = "Admin"
          }
          env {
            name  = "GF_PATHS_DATA"
            value = "/data/grafana"
          }
          image             = "grafana/grafana:5.4.0"
          image_pull_policy = "IfNotPresent"
          name              = "grafana"

          ports {
            container_port = 3000
          }
          readiness_probe {
            http_get {
              path = "/login"
              port = "3000"
            }
          }
          resources {
            requests = {
              "cpu" = "10m"
            }
          }

          volume_mounts {
            mount_path = "/data/grafana"
            name       = "data"
          }
          volume_mounts {
            mount_path = "/var/lib/grafana/dashboards/istio/galley-dashboard.json"
            name       = "dashboards-istio-galley-dashboard"
            read_only  = true
            sub_path   = "galley-dashboard.json"
          }
          volume_mounts {
            mount_path = "/var/lib/grafana/dashboards/istio/istio-mesh-dashboard.json"
            name       = "dashboards-istio-istio-mesh-dashboard"
            read_only  = true
            sub_path   = "istio-mesh-dashboard.json"
          }
          volume_mounts {
            mount_path = "/var/lib/grafana/dashboards/istio/istio-performance-dashboard.json"
            name       = "dashboards-istio-istio-performance-dashboard"
            read_only  = true
            sub_path   = "istio-performance-dashboard.json"
          }
          volume_mounts {
            mount_path = "/var/lib/grafana/dashboards/istio/istio-service-dashboard.json"
            name       = "dashboards-istio-istio-service-dashboard"
            read_only  = true
            sub_path   = "istio-service-dashboard.json"
          }
          volume_mounts {
            mount_path = "/var/lib/grafana/dashboards/istio/istio-workload-dashboard.json"
            name       = "dashboards-istio-istio-workload-dashboard"
            read_only  = true
            sub_path   = "istio-workload-dashboard.json"
          }
          volume_mounts {
            mount_path = "/var/lib/grafana/dashboards/istio/mixer-dashboard.json"
            name       = "dashboards-istio-mixer-dashboard"
            read_only  = true
            sub_path   = "mixer-dashboard.json"
          }
          volume_mounts {
            mount_path = "/var/lib/grafana/dashboards/istio/pilot-dashboard.json"
            name       = "dashboards-istio-pilot-dashboard"
            read_only  = true
            sub_path   = "pilot-dashboard.json"
          }
          volume_mounts {
            mount_path = "/etc/grafana/provisioning/datasources/datasources.yaml"
            name       = "config"
            sub_path   = "datasources.yaml"
          }
          volume_mounts {
            mount_path = "/etc/grafana/provisioning/dashboards/dashboardproviders.yaml"
            name       = "config"
            sub_path   = "dashboardproviders.yaml"
          }
        }
        security_context {
          fsgroup    = 472
          run_asuser = 472
        }

        volumes {
          config_map {
            name = "istio-grafana"
          }
          name = "config"
        }
        volumes {
          empty_dir {
          }
          name = "data"
        }
        volumes {
          config_map {
            name = "istio-grafana-configuration-dashboards-galley-dashboard"
          }
          name = "dashboards-istio-galley-dashboard"
        }
        volumes {
          config_map {
            name = "istio-grafana-configuration-dashboards-istio-mesh-dashboard"
          }
          name = "dashboards-istio-istio-mesh-dashboard"
        }
        volumes {
          config_map {
            name = "istio-grafana-configuration-dashboards-istio-performance-dashboard"
          }
          name = "dashboards-istio-istio-performance-dashboard"
        }
        volumes {
          config_map {
            name = "istio-grafana-configuration-dashboards-istio-service-dashboard"
          }
          name = "dashboards-istio-istio-service-dashboard"
        }
        volumes {
          config_map {
            name = "istio-grafana-configuration-dashboards-istio-workload-dashboard"
          }
          name = "dashboards-istio-istio-workload-dashboard"
        }
        volumes {
          config_map {
            name = "istio-grafana-configuration-dashboards-mixer-dashboard"
          }
          name = "dashboards-istio-mixer-dashboard"
        }
        volumes {
          config_map {
            name = "istio-grafana-configuration-dashboards-pilot-dashboard"
          }
          name = "dashboards-istio-pilot-dashboard"
        }
      }
    }
  }
}