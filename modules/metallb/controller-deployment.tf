resource "k8s_apps_v1_deployment" "controller" {
  metadata {
    labels = {
      "app"       = "metallb"
      "component" = "controller"
    }
    name      = "controller"
    namespace = var.namespace
  }
  spec {
    selector {
      match_labels = {
        "app"       = "metallb"
        "component" = "controller"
      }
    }
    template {
      metadata {
        annotations = {
          "prometheus.io/port"   = "7472"
          "prometheus.io/scrape" = "true"
        }
        labels = {
          "app"       = "metallb"
          "component" = "controller"
        }
      }
      spec {

        containers {
          args = [
            "--port=7472",
            "--config=config",
          ]
          image             = "metallb/controller:v0.8.1"
          image_pull_policy = "IfNotPresent"
          name              = "controller"

          ports {
            container_port = 7472
            name           = "monitoring"
          }
          resources {
            limits = {
              "cpu"    = "100m"
              "memory" = "100Mi"
            }
          }
          security_context {
            allow_privilege_escalation = false
            capabilities {
              drop = [
                "all",
              ]
            }
            read_only_root_filesystem = true
          }
        }
        node_selector = {
          "beta.kubernetes.io/os" = "linux"
        }
        security_context {
          run_asnon_root = true
          run_asuser     = 65534
        }
        service_account_name             = "controller"
        termination_grace_period_seconds = 0
      }
    }
  }
}