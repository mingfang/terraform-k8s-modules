locals {
  input_env = merge(
    var.env_file != null ? {for tuple in regexall("(\\w+)=(.+)", file(var.env_file)) : tuple[0] => tuple[1]} : {},
    var.env_map,
  )
  computed_env = [for k, v in local.input_env : { name = k, value = v }]
}

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

        command  = var.command
        env      = concat(var.env, local.computed_env)
        env_from = var.env_from

        volume_mounts = concat(
          [
            for pvc in var.pvcs :
            {
              name       = pvc.name
              mount_path = pvc.mount_path
            }
          ],
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
      [
        for pvc in var.pvcs :
        {
          name                    = pvc.name
          persistent_volume_claim = {
            claim_name = pvc.name
          }
        }
      ],
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
