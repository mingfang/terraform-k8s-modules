locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    annotations          = var.annotations
    replicas             = var.replicas
    ports                = var.ports
    enable_service_links = false

    annotations = merge(
      var.annotations,
      { "config_checksum" = md5(join("", keys(k8s_core_v1_config_map.this.data), values(k8s_core_v1_config_map.this.data))) },
    )

    containers = [
      {
        name  = "editor"
        image = var.image

        env = concat([
          {
            name = "POD_NAME"

            value_from = {
              field_ref = {
                field_path = "metadata.name"
              }
            }
          },
        ], var.env)

        volume_mounts = [
            {
              name       = "config"
              mount_path = "/nginx.conf.template"
              sub_path   = "nginx.conf.template"
            },
          ]
      }
    ]

    volumes = [
      {
        config_map = {
          name = k8s_core_v1_config_map.this.metadata[0].name
        }
        name = "config"
      },
    ]
  }
}

module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}