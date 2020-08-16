terraform {
  required_providers {
    k8s = {
      source  = "mingfang/k8s"
    }
  }
}

locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    replicas             = var.replicas
    ports                = var.ports
    enable_service_links = false

    containers = [
      {
        name  = "server"
        image = var.image
        command = [
          "sh",
          "-cx",
          <<-EOF
          prefect-server services graphql
          EOF
        ]
        env   = concat([
          {
            name = "PREFECT_SERVER__DATABASE__CONNECTION_URL"
            value = var.PREFECT_SERVER__DATABASE__CONNECTION_URL
          },
          {
            name = "PREFECT_SERVER__HASURA__HOST"
            value = var.PREFECT_SERVER__HASURA__HOST
          },
          {
            name = "PREFECT_SERVER__HASURA__PORT"
            value = var.PREFECT_SERVER__HASURA__PORT
          },
          {
            name = "PREFECT_SERVER__HASURA__ADMIN_SECRET"
            value = var.PREFECT_SERVER__HASURA__ADMIN_SECRET
          },
        ],var.env)
      },
    ]
    init_containers = [
      {
        name  = "init"
        image = var.image
        command = [
          "sh",
          "-cx",
          <<-EOF
          prefect-server database upgrade -y
          EOF
        ]
        env   = concat([
          {
            name = "PREFECT_SERVER__DATABASE__CONNECTION_URL"
            value = var.PREFECT_SERVER__DATABASE__CONNECTION_URL
          },
          {
            name = "PREFECT_SERVER__HASURA__HOST"
            value = var.PREFECT_SERVER__HASURA__HOST
          },
          {
            name = "PREFECT_SERVER__HASURA__PORT"
            value = var.PREFECT_SERVER__HASURA__PORT
          },
          {
            name = "PREFECT_SERVER__HASURA__ADMIN_SECRET"
            value = var.PREFECT_SERVER__HASURA__ADMIN_SECRET
          },
        ],var.env)
      },
    ]
  }
}

module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}