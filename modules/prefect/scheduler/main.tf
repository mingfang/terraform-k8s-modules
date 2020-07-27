locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    replicas             = var.replicas
    enable_service_links = false

    containers = [
      {
        name  = "scheduler"
        image = var.image
        command = [
          "sh",
          "-cx",
          <<-EOF
          prefect-server services scheduler
          EOF
        ]
        env   = concat([
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
          {
            name = "PREFECT_SERVER__SERVICES__SCHEDULER__SCHEDULER_LOOP_SECONDS"
            value = var.PREFECT_SERVER__SERVICES__SCHEDULER__SCHEDULER_LOOP_SECONDS
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