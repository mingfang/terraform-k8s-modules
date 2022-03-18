locals {
  parameters = {
    name        = var.name
    namespace   = var.namespace
    annotations = var.annotations
    replicas    = var.replicas
    ports       = var.ports

    enable_service_links        = false
    pod_management_policy       = "Parallel"
    publish_not_ready_addresses = true

    containers = [
      {
        name  = "trino"
        image = var.image

        env = concat([
        ], var.env)

        resources = var.resources

        volume_mounts = concat(
          var.catalog_configmap != null ? [
            for k, v in var.catalog_configmap.data :
            {
              name = "catalog"

              mount_path = "/etc/trino/catalog/${k}"
              sub_path   = k
            }
          ] : [],
          var.config_configmap != null ? [
            for k, v in var.config_configmap.data :
            {
              name = "config"

              mount_path = "/etc/trino/${k}"
              sub_path   = k
            }
          ] : []
        )
      },
    ]

    volumes = concat(
      var.catalog_configmap != null ? [
        {
          name = "catalog"

          config_map = {
            name = var.catalog_configmap.metadata[0].name
          }
        }
      ] : [],
      var.config_configmap != null ? [
        {
          name = "config"

          config_map = {
            name = var.config_configmap.metadata[0].name
          }
        }
      ] : [],
    )

  }
}

module "statefulset-service" {
  source     = "../../archetypes/statefulset-service"
  parameters = merge(local.parameters, var.overrides)
}