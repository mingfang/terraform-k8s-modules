/**
 * [Fluent Bit](https://fluentbit.io)
 *
 * FluentBit Runs as a daemonset sending logs directly to Elasticsearch
 */

locals {
  labels = {
    app     = var.name
    name    = var.name
    service = var.name
  }
  parameters = {
    name      = var.name
    namespace = var.namespace
    labels    = local.labels

    containers = [
      {
        name  = "minifi"
        image = var.image

        volume_mounts = [
          {
            name       = "config"
            mount_path = "/opt/minifi/minifi-0.5.0/conf/bootstrap.conf"
            sub_path   = "bootstrap.conf"
          },
        ]
      },
    ]
    volumes = [
      {
        name = "config"
        config_map = {
          name = k8s_core_v1_config_map.this.metadata.0.name
        }
      },
    ]
  }
}

module "daemonset" {
  source     = "git::https://github.com/mingfang/terraform-provider-k8s.git//archetypes/daemonset"
  parameters = merge(local.parameters, var.overrides)
}