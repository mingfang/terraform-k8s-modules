locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    replicas             = var.replicas
    ports                = var.ports
    annotations          = var.annotations
    enable_service_links = false

    containers = [
      {
        name  = "superset"
        image = var.image
        env   = var.env

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

    affinity = {
      pod_anti_affinity = {
        required_during_scheduling_ignored_during_execution = [
          {
            label_selector = {
              match_expressions = [
                {
                  key      = "name"
                  operator = "In"
                  values   = [var.name]
                }
              ]
            }
            topology_key = "kubernetes.io/hostname"
          }
        ]
      }
    }

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
  source     = "../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}