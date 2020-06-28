locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    annotations          = var.annotations
    replicas             = var.replicas
    enable_service_links = false

    containers = [
      {
        name  = "faas-idler"
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
            name  = "gateway_url"
            value = var.gateway_url
          },
          {
            name  = "prometheus_host"
            value = var.prometheus_host
          },
          {
            name  = "prometheus_port"
            value = var.prometheus_port
          },
          {
            name  = "inactivity_duration"
            value = var.inactivity_duration
          },
          {
            name  = "reconcile_interval"
            value = var.reconcile_interval
          },
          {
            name  = "write_debug"
            value = var.write_debug
          },
        ], var.env)

        resources = var.resources
      },
    ]
  }
}

module "deployment-service" {
  source         = "../../../archetypes/deployment-service"
  parameters     = merge(local.parameters, var.overrides)
  enable_service = false
}