resource "k8s_apps_v1_deployment" "hub" {
  metadata {
    labels = {
      "app"       = "jupyterhub"
      "chart"     = "jupyterhub-0.8.2"
      "component" = "hub"
      "heritage"  = "Helm"
      "release"   = "RELEASE-NAME"
    }
    name = "hub"
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        "app"       = "jupyterhub"
        "component" = "hub"
        "release"   = "RELEASE-NAME"
      }
    }
    strategy {
      type = "Recreate"
    }
    template {
      metadata {
        annotations = {
          "checksum/config-map" = "c7420881c123dc766850df7e395073f2f17f8b05c40cb1fdbeb20d4a0ab207d3"
          "checksum/secret"     = "9eb2d1e496665da31814d5b8f79a07439aff72987ca82a1efe5ef0fd12642946"
        }
        labels = {
          "app"                                       = "jupyterhub"
          "component"                                 = "hub"
          "hub.jupyter.org/network-access-proxy-api"  = "true"
          "hub.jupyter.org/network-access-proxy-http" = "true"
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
            "jupyterhub",
            "--config",
            "/srv/jupyterhub_config.py",
          ]

          env {
            name  = "PYTHONUNBUFFERED"
            value = "1"
          }
          env {
            name  = "HELM_RELEASE_NAME"
            value = "RELEASE-NAME"
          }
          env {
            name = "JPY_COOKIE_SECRET"
            value_from {
              secret_key_ref {
                key  = "hub.cookie-secret"
                name = "hub-secret"
              }
            }
          }
          env {
            name = "POD_NAMESPACE"
            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }
          env {
            name = "CONFIGPROXY_AUTH_TOKEN"
            value_from {
              secret_key_ref {
                key  = "proxy.token"
                name = "hub-secret"
              }
            }
          }
          image             = "jupyterhub/k8s-hub:0.8.2"
          image_pull_policy = "IfNotPresent"
          name              = "hub"

          ports {
            container_port = 8081
            name           = "hub"
          }
          resources {
            requests = {
              "cpu"    = "200m"
              "memory" = "512Mi"
            }
          }

          volume_mounts {
            mount_path = "/etc/jupyterhub/config/"
            name       = "config"
          }
          volume_mounts {
            mount_path = "/etc/jupyterhub/secret/"
            name       = "secret"
          }
        }
        node_selector = {
        }
        security_context {
          fsgroup    = 1000
          run_asuser = 1000
        }
        service_account_name = "hub"

        volumes {
          config_map {
            name = "hub-config"
          }
          name = "config"
        }
        volumes {
          name = "secret"
          secret {
            secret_name = "hub-secret"
          }
        }
      }
    }
  }
}