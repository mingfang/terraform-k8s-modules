resource "k8s_apps_v1_deployment" "istio_citadel" {
  metadata {
    labels = {
      "app"      = "security"
      "chart"    = "security"
      "heritage" = "Tiller"
      "istio"    = "citadel"
      "release"  = "istio"
    }
    name      = "istio-citadel"
    namespace = var.namespace
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        "istio" = "citadel"
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
          "app"      = "security"
          "chart"    = "security"
          "heritage" = "Tiller"
          "istio"    = "citadel"
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
            "--append-dns-names=true",
            "--grpc-port=8060",
            "--citadel-storage-namespace=${var.namespace}",
            "--custom-dns-names=istio-pilot-service-account.${var.namespace}:istio-pilot.${var.namespace}",
            "--monitoring-port=15014",
            "--self-signed-ca=true",
            "--workload-cert-ttl=2160h",
          ]

          env {
            name  = "CITADEL_ENABLE_NAMESPACES_BY_DEFAULT"
            value = "true"
          }
          image             = "docker.io/istio/citadel:1.5.2"
          image_pull_policy = "IfNotPresent"
          name              = "citadel"
          resources {
            requests = {
              "cpu" = "10m"
            }
          }
        }
        service_account_name = "istio-citadel-service-account"
      }
    }
  }
}