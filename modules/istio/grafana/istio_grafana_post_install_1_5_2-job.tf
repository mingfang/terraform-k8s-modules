resource "k8s_batch_v1_job" "istio_grafana_post_install_1_5_2" {
  metadata {
    annotations = {
      "helm.sh/hook"               = "post-install"
      "helm.sh/hook-delete-policy" = "hook-succeeded"
    }
    labels = {
      "app"      = "grafana"
      "chart"    = "grafana"
      "heritage" = "Tiller"
      "release"  = "istio"
    }
    name      = "istio-grafana-post-install-1.5.2"
    namespace = var.namespace
  }
  spec {
    template {
      metadata {
        annotations = {
          "sidecar.istio.io/inject" = "false"
        }
        labels = {
          "app"      = "istio-grafana"
          "chart"    = "grafana"
          "heritage" = "Tiller"
          "release"  = "istio"
        }
        name = "istio-grafana-post-install"
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
            "/bin/bash",
            "/tmp/grafana/run.sh",
            "/tmp/grafana/custom-resources.yaml",
          ]
          image = "docker.io/istio/kubectl:1.5.2"
          name  = "kubectl"

          volume_mounts {
            mount_path = "/tmp/grafana"
            name       = "tmp-configmap-grafana"
          }
        }
        restart_policy       = "OnFailure"
        service_account_name = "istio-grafana-post-install-account"

        volumes {
          config_map {
            name = "istio-grafana-custom-resources"
          }
          name = "tmp-configmap-grafana"
        }
      }
    }
  }
}