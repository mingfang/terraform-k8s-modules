locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    replicas             = var.replicas
    annotations          = var.annotations
    enable_service_links = false

    containers = [
      {
        name    = var.type
        image   = var.image
        command = ["bash", "-c", "celery --app=superset.tasks.celery_app:app ${var.type} --pidfile /tmp/celery.pid --schedule /tmp/celery-schedule"]
        env     = var.env

        volume_mounts = var.config_configmap != null ? [
          for k, v in var.config_configmap.data :
          {
            name = "config"

            mount_path = "/app/pythonpath/${k}"
            sub_path   = k
          }
        ] : []
      },
    ]

    volumes = var.config_configmap != null ? [
      {
        name = "config"
        config_map = {
          name = var.config_configmap.metadata[0].name
        }
      }
    ] : []

  }
}

module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}