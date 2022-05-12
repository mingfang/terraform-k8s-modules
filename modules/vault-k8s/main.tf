locals {
  parameters = {
    name        = var.name
    namespace   = var.namespace
    replicas    = var.replicas
    ports       = var.ports
    annotations = var.annotations

    enable_service_links = false

    containers = [
      {
        name  = "sidecar-injector"
        image = var.image

        args = ["agent-inject", "2>&1", ]

        env = concat([
          {
            name = "NAMESPACE"
            value_from = {
              field_ref = {
                field_path = "metadata.namespace"
              }
            }
          },
          {
            name = "POD_NAME"
            value_from = {
              field_ref = {
                field_path = "metadata.name"
              }
            }
          },
          {
            name  = "AGENT_INJECT_LISTEN"
            value = ":${var.ports[0].port}"
          },
          {
            name  = "AGENT_INJECT_LOG_LEVEL"
            value = var.AGENT_INJECT_LOG_LEVEL
          },
          {
            name  = "AGENT_INJECT_LOG_FORMAT"
            value = "standard"
          },
          {
            name  = "AGENT_INJECT_VAULT_ADDR"
            value = var.AGENT_INJECT_VAULT_ADDR
          },
          {
            name  = "AGENT_INJECT_VAULT_IMAGE"
            value = var.AGENT_INJECT_VAULT_IMAGE
          },
          {
            name  = "AGENT_INJECT_TLS_AUTO"
            value = var.name
          },
          {
            name  = "AGENT_INJECT_TLS_AUTO_HOSTS"
            value = "${var.name},${var.name}.$(NAMESPACE),${var.name}.$(NAMESPACE).svc"
          },
          {
            name  = "AGENT_INJECT_USE_LEADER_ELECTOR"
            value = "false"
          },
          {
            name  = "AGENT_INJECT_DEFAULT_TEMPLATE"
            value = "map"
          },
          {
            name  = "AGENT_INJECT_CPU_REQUEST"
            value = "250m"
          },
          {
            name  = "AGENT_INJECT_MEM_REQUEST"
            value = "64Mi"
          },
          {
            name  = "AGENT_INJECT_CPU_LIMIT"
            value = "500m"
          },
          {
            name  = "AGENT_INJECT_MEM_LIMIT"
            value = "128Mi"
          },
        ], var.env)

        liveness_probe = {
          http_get = {
            path   = "/health/ready"
            port   = var.ports[0].port
            scheme = "HTTPS"
          }
          failure_threshold     = 2
          initial_delay_seconds = 1
          period_seconds        = 2
          success_threshold     = 1
          timeout_seconds       = 5
        }

        readiness_probe = {
          http_get = {
            path   = "/health/ready"
            port   = var.ports[0].port
            scheme = "HTTPS"
          }
          failure_threshold     = 2
          initial_delay_seconds = 2
          period_seconds        = 2
          success_threshold     = 1
          timeout_seconds       = 5
        }
      },
    ]

    service_account_name = module.rbac.name
  }
}

module "deployment-service" {
  source     = "../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
