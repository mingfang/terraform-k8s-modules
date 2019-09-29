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
    annotations = var.annotations
    replicas  = var.replicas
    ports = var.ports

    containers = [
      {
        command = [
          "configurable-http-proxy",
          "--ip=0.0.0.0",
          "--api-ip=0.0.0.0",
          "--api-port=8001",
          "--default-target=http://$(HUB_SERVICE_HOST):$(HUB_SERVICE_PORT)",
          "--error-target=http://$(HUB_SERVICE_HOST):$(HUB_SERVICE_PORT)/hub/error",
          "--port=${var.ports[0].port}",
        ]

        env = [
          {
            name  = "HUB_SERVICE_HOST"
            value = var.hub_service_host
          },
          {
            name  = "HUB_SERVICE_PORT"
            value = var.hub_service_port
          },
          {
            name = "CONFIGPROXY_AUTH_TOKEN"
            value_from = {
              secret_key_ref = {
                key  = "proxy.token"
                name = var.secret_name
              }
            }
          },
        ]

        image = var.image
        name  = "chp"

        resources = {
          requests = {
            "cpu"    = "200m"
            "memory" = "512Mi"
          }
        }
      }
    ]
  }
}

module "deployment-service" {
  source     = "git::https://github.com/mingfang/terraform-provider-k8s.git//archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}

