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
        name  = "sentry"
        image = var.image
        args  = ["run", "web"]

        env_from = [
          {
            config_map_ref = {
              name = var.env_config_map
            }
          },
        ]

        lifecycle = {
          post_start = {
            exec = {
              command = [
                "sh",
                "-cx",
                <<-EOF
                sentry createuser --email mingfang@mac.com --password mingfang123 --superuser || true
                EOF
              ]
            }
          }
        }

        liveness_probe = {
          http_get = {
            path = "/_health/"
            port = 9000
          }
        }

        volume_mounts = var.etc_config_map != null ? [
          {
            name       = "etc"
            mount_path = "/etc/sentry"
          }
        ] : []

      },
    ]

    init_containers = [
      {
        name  = "init"
        image = var.image
        args  = ["sentry", "upgrade", "--noinput"]

        env_from = [
          {
            config_map_ref = {
              name = var.env_config_map
            }
          },
        ]

        volume_mounts = var.etc_config_map != null ? [
          {
            name       = "etc"
            mount_path = "/etc/sentry"
          }
        ] : []
      },
    ]

    volumes = var.etc_config_map != null ? [
      {
        name = "etc"
        config_map = {
          name         = var.etc_config_map
          default_mode = parseint("0644", 8)
        }
      }
    ] : []
  }
}

module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
