/**
 * Documentation
 *
 * terraform-docs --sort-inputs-by-required --with-aggregate-type-defaults md
 *
 */

locals {
  labels = {
    app     = var.name
    name    = var.name
    service = var.name
  }

  parameters = {
    name                 = var.name
    namespace            = var.namespace
    labels               = local.labels
    replicas             = 1
    ports                = var.ports
    enable_service_links = false

    containers = [
      {
        name  = "minifi-c2"
        image = var.image
        env = [
          {
            name  = "NIFI_REST_API_URL"
            value = var.NIFI_REST_API_URL
          }
        ]
        volume_mounts = [
          {
            name       = "context"
            mount_path = "/opt/minifi-c2/minifi-c2-0.5.0/conf/minifi-c2-context.xml"
            sub_path   = "minifi-c2-context.xml"
          },
        ]
      },
    ]
    volumes = [
      {
        name = "context"
        config_map = {
          name = k8s_core_v1_config_map.context.metadata.0.name
        }
      },
    ]
  }
}

module "statefulset-service" {
  source     = "git::https://github.com/mingfang/terraform-provider-k8s.git//archetypes/statefulset-service"
  parameters = merge(local.parameters, var.overrides)
}