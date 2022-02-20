locals {
  parameters = {
    name        = var.name
    namespace   = var.namespace
    annotations = var.annotations

    containers = [
      {
        name  = var.name
        image = var.image

        command = var.command
        env     = var.env
      },
    ]

    backoff_limit  = var.backoff_limit
    restart_policy = var.restart_policy
  }
}

module "job" {
  source     = "../../../archetypes/job"
  parameters = merge(local.parameters, var.overrides)
}