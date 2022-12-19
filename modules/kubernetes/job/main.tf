locals {
  parameters = {
    name        = var.name
    namespace   = var.namespace
    annotations = merge(
      var.annotations,
      var.configmap != null ? {
        config_checksum = md5(join("", keys(var.configmap.data), values(var.configmap.data)))
      } : {},
    )

    enable_service_links = false

    containers = [
      {
        name  = var.name
        image = var.image

        command       = var.command
        env           = var.env
        env_from      = var.env_from
        volume_mounts = concat(
          var.volume_mounts,
          var.configmap != null ? [
          for k, v in var.configmap.data :
          {
            name       = "config"
            mount_path = "/config/${k}"
            sub_path   = k
          }
          ] : [],
          var.secret != null ? [
          for k, v in var.secret.data :
          {
            name       = "secret"
            mount_path = "/config/${k}"
            sub_path   = k
          }
          ] : [],
          [], #hack - sometimes sub_path is ignored without this
        )
      },
    ]

    backoff_limit  = var.backoff_limit
    restart_policy = var.restart_policy
    volumes        = concat(
      var.volumes,
      var.configmap != null ? [
        {
          name = "config"

          config_map = {
            name = var.configmap.metadata[0].name
          }
        }
      ] : [],
      var.secret != null ? [
        {
          name = "secret"

          secret_map = {
            name = var.secret.metadata[0].name
          }
        }
      ] : [],
      )
  }
}

module "job" {
  source     = "../../../archetypes/job"
  parameters = merge(local.parameters, var.overrides)
}
