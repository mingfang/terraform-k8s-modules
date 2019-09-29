resource "k8s_batch_v1_job" "istio-cleanup-secrets-1_1_2" {
  metadata {
    annotations = {
      "helm.sh/hook"               = "post-delete"
      "helm.sh/hook-delete-policy" = "hook-succeeded"
      "helm.sh/hook-weight"        = "3"
    }
    labels = {
      "app"      = "security"
      "chart"    = "security"
      "heritage" = "Tiller"
      "release"  = "istio"
    }
    name      = "istio-cleanup-secrets-1.1.2"
    namespace = "${var.namespace}"
  }
  spec {
    template {
      metadata {
        labels = {
          "app"      = "security"
          "chart"    = "security"
          "heritage" = "Tiller"
          "release"  = "istio"
        }
        name = "istio-cleanup-secrets"
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
            "-c",
            <<-EOF
            kubectl get secret --all-namespaces | grep "istio.io/key-and-cert" |  while read -r entry; do
              ns=$(echo $entry | awk '{print $1}');
              name=$(echo $entry | awk '{print $2}');
              kubectl delete secret $name -n $ns;
            done
            
            EOF
            ,
          ]
          image = "docker.io/istio/kubectl:1.1.2"
          image_pull_policy = "IfNotPresent"
          name = "kubectl"
        }
        restart_policy = "OnFailure"
        service_account_name = "istio-cleanup-secrets-service-account"
      }
    }
  }
}