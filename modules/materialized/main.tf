locals {
  parameters = {
    name        = var.name
    namespace   = var.namespace
    replicas    = var.replicas
    ports       = var.ports
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

        volume_mounts = concat(
          var.pvc != null ? [
            {
              name       = "data"
              mount_path = "/mzdata"
            },
          ] : [],
          var.configmap != null ? [
          for k, v in var.configmap.data :
          {
            name       = "config"
            mount_path = "/etc/${var.name}/${k}"
            sub_path   = k
          }
          ] : [],
        )
      },
      {
        name = "mzcli"
        image = "materialize/cli"
        command = ["sleep", "infinity"]
      },
    ]

    node_selector = var.node_selector

    volumes = concat(
      var.pvc != null ? [
        {
          name = "data"

          persistent_volume_claim = {
            claim_name = var.pvc
          }
        }
      ] : [],
      var.configmap != null ? [
        {
          name = "config"

          config_map = {
            name = var.configmap.metadata[0].name
          }
        }
      ] : [],
    )
  }
}

module "deployment-service" {
  source     = "../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}