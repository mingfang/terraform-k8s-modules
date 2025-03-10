locals {
  parameters = {
    name        = var.name
    namespace   = var.namespace
    annotations = var.annotations
    enable_service_links = false

    containers = [
      {
        name  = "import-data"
        image = var.image

        env = var.env
      },
    ]

    restart_policy = "OnFailure"
  }
}


module "job" {
  source     = "../../../archetypes/job"
  parameters = merge(local.parameters, var.overrides)
}
