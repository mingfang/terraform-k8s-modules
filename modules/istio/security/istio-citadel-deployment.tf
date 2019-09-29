resource "k8s_extensions_v1beta1_deployment" "istio-citadel" {
  metadata {
    labels = {
      "app"      = "security"
      "chart"    = "security"
      "heritage" = "Tiller"
      "istio"    = "citadel"
      "release"  = "istio"
    }
    name      = "istio-citadel"
    namespace = "${var.namespace}"
  }
  spec {
    replicas = 1
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
            "--grpc-hostname=citadel",
            "--citadel-storage-namespace=${var.namespace}",
            "--custom-dns-names=istio-pilot-service-account.istio-system:istio-pilot.${var.namespace}",
            "--monitoring-port=15014",
            "--self-signed-ca=true",
          ]
          image             = "docker.io/istio/citadel:1.1.2"
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