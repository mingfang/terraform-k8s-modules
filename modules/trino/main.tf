locals {
  parameters = {
    name      = var.name
    namespace = var.namespace
    replicas  = var.replicas
    ports     = var.ports

    annotations = merge(
      var.annotations,
      var.config_configmap != null ? { config_checksum = md5(join("", keys(var.config_configmap.data), values(var.config_configmap.data))) } : {},
      var.catalog_configmap != null ? { catalog_checksum = md5(join("", keys(var.catalog_configmap.data), values(var.catalog_configmap.data))) } : {},
    )

    enable_service_links        = false
    pod_management_policy       = "Parallel"
    publish_not_ready_addresses = true

    containers = [
      {
        name  = "trino"
        image = var.image

        env = concat([
        ], var.env)

        env_from = var.env_from

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