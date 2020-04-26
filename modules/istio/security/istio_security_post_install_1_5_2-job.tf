resource "k8s_batch_v1_job" "istio_security_post_install_1_5_2" {
  metadata {
    annotations = {
      "helm.sh/hook"               = "post-install,post-upgrade"
      "helm.sh/hook-delete-policy" = "hook-succeeded"
    }
    labels = {
      "app"      = "security"
      "chart"    = "security"
      "heritage" = "Tiller"
      "release"  = "istio"
    }
    name      = "istio-security-post-install-1.5.2"
    namespace = var.namespace
  }
  spec {
    template {
      metadata {
        annotations = {
          "sidecar.istio.io/inject" = "false"
        }
        labels = {
          "app"      = "security"
          "chart"    = "security"
          "heritage" = "Tiller"
          "release"  = "istio"
        }
        name = "istio-security-post-install"
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
            "/tmp/security/run.sh",
            "/tmp/security/custom-resources.yaml",
          ]
          image             = "docker.io/istio/kubectl:1.5.2"
          image_pull_policy = "IfNotPresent"
          name              = "kubectl"

          volume_mounts {
            mount_path = "/tmp/security"
            name       = "tmp-configmap-security"
          }
        }
        restart_policy       = "OnFailure"
        service_account_name = "istio-security-post-install-account"

        volumes {
          config_map {
            name = "istio-security-custom-resources"
          }
          name = "tmp-configmap-security"
        }
      }
    }
  }
}