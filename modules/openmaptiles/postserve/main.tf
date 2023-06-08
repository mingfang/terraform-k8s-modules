locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    annotations          = var.annotations
    replicas             = var.replicas
    ports                = var.ports
    enable_service_links = false

    containers = [
      {
        name  = "postserve"
        image = var.image
        command: [
          "sh",
          "-cx",
          <<-EOF
          postserve $TILESET_FILE --verbose --serve=http://localhost:${var.ports[0].port}
          EOF
        ]
        env = concat([
          {
            name = "TILESET_FILE"
            value = var.TILESET_FILE
          }
        ], var.env)

        volume_mounts = [
          {
            name       = "tileset"
            mount_path = "/tileset"
          },
        ]
      }
    ]

    init_containers = [
      {
        name = "init"
        image = "alpine/git"
        command: [
          "sh",
          "-cx",
          <<-EOF
          git clone --depth=1  https://github.com/openmaptiles/openmaptiles.git /tileset
          EOF
        ]
        volume_mounts = [
          {
            name       = "tileset"
            mount_path = "/tileset"
          },
        ]
      }
    ]

    volumes = [
      {
        name = "tileset"

        empty_dir = {
          "medium" = "Memory"
        }
      },
    ]
  }
}

module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
