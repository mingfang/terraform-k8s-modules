locals {
  parameters = {
    name                        = var.name
    namespace                   = var.namespace
    annotations                 = var.annotations
    replicas                    = var.replicas
    ports                       = var.ports
    enable_service_links        = false
    pod_management_policy       = "Parallel"
    publish_not_ready_addresses = true

    containers = [
      {
        name  = "realtime"
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
            name = "POD_IP"

            value_from = {
              field_ref = {
                field_path = "status.podIP"
              }
            }
          },
          {
            name  = "GOTRUE_JWT_SECRET"
            value = var.GOTRUE_JWT_SECRET
          },
          {
            name  = "GOTRUE_JWT_EXP"
            value = var.GOTRUE_JWT_EXP
          },
          {
            name  = "GOTRUE_JWT_DEFAULT_GROUP_NAME"
            value = var.GOTRUE_JWT_DEFAULT_GROUP_NAME
          },
          {
            name  = "GOTRUE_DB_DRIVER"
            value = var.GOTRUE_DB_DRIVER
          },
          {
            name  = "DB_NAMESPACE"
            value = var.DB_NAMESPACE
          },
          {
            name  = "API_EXTERNAL_URL"
            value = var.API_EXTERNAL_URL
          },
          {
            name  = "GOTRUE_API_HOST"
            value = var.GOTRUE_API_HOST
          },
          {
            name  = "PORT"
            value = var.ports[0].port
          },
          {
            name  = "GOTRUE_SMTP_HOST"
            value = var.GOTRUE_SMTP_HOST
          },
          {
            name  = "GOTRUE_SMTP_PORT"
            value = var.GOTRUE_SMTP_PORT
          },
          {
            name  = "GOTRUE_SMTP_USER"
            value = var.GOTRUE_SMTP_USER
          },
          {
            name  = "GOTRUE_SMTP_PASS"
            value = var.GOTRUE_SMTP_PASS
          },
          {
            name  = "GOTRUE_DISABLE_SIGNUP"
            value = var.GOTRUE_DISABLE_SIGNUP
          },
          {
            name  = "GOTRUE_SITE_URL"
            value = var.GOTRUE_SITE_URL
          },
          {
            name  = "GOTRUE_MAILER_AUTOCONFIRM"
            value = var.GOTRUE_MAILER_AUTOCONFIRM
          },
          {
            name  = "GOTRUE_LOG_LEVEL"
            value = var.GOTRUE_LOG_LEVEL
          },
          {
            name  = "GOTRUE_OPERATOR_TOKEN"
            value = var.GOTRUE_OPERATOR_TOKEN
          },
          {
            name  = "DATABASE_URL"
            value = var.DATABASE_URL
          },
        ], var.env)

        resources = var.resources
      },
    ]
  }
}

module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}