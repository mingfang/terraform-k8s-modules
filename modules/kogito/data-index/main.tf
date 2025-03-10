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
        name  = "data-index"
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
          {
            name  = "KOGITO_DATA_INDEX_PROPS"
            value = "-Dkogito.protobuf.folder=/home/kogito/data/protobufs/"
          },
        ], var.env)

        volume_mounts = concat(
          var.protobufs != null ? [
            {
              name       = "protobufs"
              mount_path = "/home/kogito/data/protobufs"
            },
          ] : [],
        )
      }
    ]

    volumes = var.protobufs != null ? [
      {
        config_map = {
          name = var.protobufs
        }
        name = "protobufs"
      },
    ] : []
  }
}

module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
