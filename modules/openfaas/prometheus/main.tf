locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    annotations          = var.annotations
    replicas             = var.replicas
    ports                = var.ports
    enable_service_links = false

    containers = [
      {
        name  = "prometheus"
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
        ], var.env)

        liveness_probe = {
          http_get = {
            path = "/-/healthy"
            port = 9090
          }
          timeout_seconds = 30
        }
        readiness_probe = {
          http_get = {
            path = "/-/healthy"
            port = 9090
          }
          timeout_seconds = 30
        }

        resources = var.resources

        volume_mounts = [
          {
            name       = "config"
            mount_path = "/etc/prometheus"
          }
        ]
      },
    ]
    service_account_name = module.rbac.name

    volumes = [
      {
        name = "config"
        config_map = {
          name = module.config.name
        }
      }
    ]
  }
}

module "config" {
  source    = "../../kubernetes/config-map"
  name      = var.name
  namespace = var.namespace

  from-map = {
    "prometheus.yml" = templatefile("${path.module}/prometheus.yml", {
      namespaces = join(",", compact([var.namespace, var.function_namespace]))
    })
    "alert.rules.yml" = file("${path.module}/alert.rules.yml")
  }
}

module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}