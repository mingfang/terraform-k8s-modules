resource "k8s_apps_v1_deployment" "proxy" {
  metadata {
    labels = {
      "app"       = "jupyterhub"
      "chart"     = "jupyterhub-0.8.2"
      "component" = "proxy"
      "heritage"  = "Helm"
      "release"   = "RELEASE-NAME"
    }
    name = "proxy"
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        "app"       = "jupyterhub"
        "component" = "proxy"
        "release"   = "RELEASE-NAME"
      }
    }
    template {
      metadata {
        annotations = {
          "checksum/hub-secret"   = "ac2c06c75cb0a0e7055168f5490674fdf9ab151e3832b95cbaf9e1aedce58a3e"
          "checksum/proxy-secret" = "01ba4719c80b6fe911b091a7c05124b64eeece964e09c058ef8f9805daca546b"
        }
        labels = {
          "app"                                       = "jupyterhub"
          "component"                                 = "proxy"
          "hub.jupyter.org/network-access-hub"        = "true"
          "hub.jupyter.org/network-access-singleuser" = "true"
          "release"                                   = "RELEASE-NAME"
        }
      }
      spec {
        affinity {
          node_affinity {

            preferred_during_scheduling_ignored_during_execution {
              preference {

                match_expressions {
                  key      = "hub.jupyter.org/node-purpose"
                  operator = "In"
                  values = [
                    "core",
                  ]
                }
              }
              weight = 100
            }
          }
        }

        containers {
          command = [
            "configurable-http-proxy",
            "--ip=0.0.0.0",
            "--api-ip=0.0.0.0",
            "--api-port=8001",
            "--default-target=http://$(HUB_SERVICE_HOST):$(HUB_SERVICE_PORT)",
            "--error-target=http://$(HUB_SERVICE_HOST):$(HUB_SERVICE_PORT)/hub/error",
            "--port=8000",
          ]

          env {
            name = "CONFIGPROXY_AUTH_TOKEN"
            value_from {
              secret_key_ref {
                key  = "proxy.token"
                name = "hub-secret"
              }
            }
          }
          image             = "jupyterhub/configurable-http-proxy:3.0.0"
          image_pull_policy = "IfNotPresent"
          name              = "chp"

          ports {
            container_port = 8000
            name           = "proxy-public"
          }
          ports {
            container_port = 8001
            name           = "api"
          }
          resources {
            requests = {
              "cpu"    = "200m"
              "memory" = "512Mi"
            }
          }
        }
        node_selector = {
        }
        termination_grace_period_seconds = 60
      }
    }
  }
}