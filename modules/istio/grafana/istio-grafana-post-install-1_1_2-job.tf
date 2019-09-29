resource "k8s_batch_v1_job" "istio-grafana-post-install-1_1_2" {
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
    name      = "istio-grafana-post-install-1.1.2"
    namespace = "${var.namespace}"
  }
  spec {
    template {
      metadata {
        labels = {
          "app"      = "istio-grafana"
          "chart"    = "grafana"
          "heritage" = "Tiller"
          "release"  = "istio"
        }
        name = "istio-grafana-post-install"
      }
      spec {

        containers {
          command = [
            "/bin/bash",
            "/tmp/grafana/run.sh",
            "/tmp/grafana/custom-resources.yaml",
          ]
          image = "docker.io/istio/kubectl:1.1.2"
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