/**
 * [Kibana](https://www.elastic.co/products/kibana)
 *
 *
 */

locals {
  parameters = {
    name        = var.name
    namespace   = var.namespace
    annotations = var.annotations
    replicas    = var.replicas
    ports       = var.ports
    containers = [
      {
        name  = "kibana"
        image = var.image
        env = concat([
          {
            name  = "SERVER_NAME"
            value = var.server_name
          },
          {
            name  = "SERVER_HOST"
            value = var.server_host
          },
          {
            name  = "ELASTICSEARCH_URL"
            value = var.elasticsearch_url
          },
          {
            name  = "XPACK_MONITORING_UI_CONTAINER_ELASTICSEARCH_ENABLED"
            value = var.xpack_monitoring_ui_container_elasticsearch_enabled
          },
        ], var.env)

        liveness_probe = {
          failure_threshold     = 3
          initial_delay_seconds = 60
          period_seconds        = 10
          success_threshold     = 1
          timeout_seconds       = 1

          http_get = {
            path   = "/status"
            port   = var.ports.0.port
            scheme = "HTTP"
          }
        }

        readiness_probe = {
          failure_threshold     = 3
          initial_delay_seconds = 5
          period_seconds        = 10
          success_threshold     = 1
          timeout_seconds       = 1

          http_get = {
            path   = "/status"
            port   = var.ports.0.port
            scheme = "HTTP"
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
