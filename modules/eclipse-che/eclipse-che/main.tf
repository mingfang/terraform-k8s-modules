/**
 * Documentation
 *
 * terraform-docs --sort-inputs-by-required --with-aggregate-type-defaults md
 *
 */

locals {
  parameters = {
    name      = var.name
    namespace = var.namespace
    annotations = merge(
      var.annotations,
      {
        "config_checksum" = md5(join("", keys(k8s_core_v1_config_map.che.data), values(k8s_core_v1_config_map.che.data)))
      },
      var.CHE_METRICS_ENABLED ? {
        "prometheus.io/port": "8087",
        "prometheus.io/scrape": "true"
      } : {},
    )
    replicas             = var.replicas
    ports                = var.ports
    enable_service_links = false
    labels = {
      app       = "che"
      component = "che"
    }

    containers = [
      {
        name  = "che"
        image = var.image

        env = concat([
          {
            name = "POD_NAME"
            value_from = {
              field_ref = {
                field_path = "metadata.name"
              }
            }
          },
          {
            name = "KUBERNETES_NAMESPACE"
            value_from = {
              field_ref = {
                field_path = "metadata.namespace"
              }
            }
          }
        ], var.env)

        env_from = [
          {
            config_map_ref = {
              name = k8s_core_v1_config_map.che.metadata[0].name
            }
          },
        ]

        liveness_probe = {
          http_get = {
            path = "/api/system/state"
            port = "8080"
          }
          initial_delay_seconds = 120
          timeout_seconds       = 10
        }
        readiness_probe = {
          http_get = {
            path = "/api/system/state"
            port = "8080"
          }
          initial_delay_seconds = 15
          timeout_seconds       = 60
        }

        resources = {
          limits = {
            "memory" = "600Mi"
          }
          requests = {
            "memory" = "256Mi"
          }
        }

        security_context = {
          run_asuser = 1724
        }
      },
    ]

    security_context = {
      fsgroup = 1724
    }
    service_account_name = k8s_core_v1_service_account.che.metadata[0].name
    strategy = {
      type = "Recreate"
    }
  }
}

module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
