locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    replicas             = var.replicas
    ports                = var.ports
    enable_service_links = false

    annotations = merge(
      var.annotations,
      {
        "prometheus.io/scrape" = "true"
        "prometheus.io/port"   = "16686"
      },
    )

    containers = [
      {
        name  = "jaeger-query"
        image = var.image
        args  = ["--config-file=/conf/query.yaml"]
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
            name = "SPAN_STORAGE_TYPE"
            value_from = {
              config_map_key_ref = {
                name = var.config_map_name
                key  = "span-storage-type"
              }
            }
          }
        ], var.env)

        readiness_probe = {
          http_get = {
            path = "/"
            port = 16687
          }
        }

        volume_mounts = [
          {
            name       = "config"
            mount_path = "/conf"
          },
        ]
      }
    ]

    volumes = [
      {
        name = "config"
        config_map = {
          name = var.config_map_name
          items = [
            {
              key  = "query"
              path = "query.yaml"
            }
          ]
        }
      },
    ]
  }
}

module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
