locals {
  parameters = {
    name        = var.name
    namespace   = var.namespace
    replicas    = var.replicas
    ports       = var.ports
    annotations = merge(
      var.annotations,
      {
        config_checksum = md5(join("", keys(module.config.config_map.data), values(module.config.config_map.data)))
      }
    )

    enable_service_links = false

    containers = [
      {
        name    = var.name
        image   = var.image
        command = [
          "sh",
          "-c",
          <<-EOF
          npx react-inject-env set -d ./ &&
          nginx -g 'daemon off;'
          EOF
        ]

        env = concat([
          {
            name = "POD_NAME"

            value_from = {
              field_ref = {
                field_path = "metadata.name"
              }
            }
          },
          {
            name = "POD_IP"

            value_from = {
              field_ref = {
                field_path = "status.podIP"
              }
            }
          },
        ], var.env)

        resources = var.resources

        volume_mounts = [
        for k, v in module.config.config_map.data :
        {
          name       = "config"
          mount_path = "/etc/nginx/conf.d/${k}"
          sub_path   = k
        }
        ]
      },
    ]

    node_selector        = var.node_selector
    service_account_name = var.service_account_name

    volumes = [
      {
        name = "config"

        config_map = {
          name = module.config.config_map.metadata[0].name
        }
      }
    ],
  }
}

module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}