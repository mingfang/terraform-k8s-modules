locals {
  parameters = {
    name      = var.name
    namespace = var.namespace
    // restart on config change
    annotations = merge(var.annotations, { checksum = module.config.checksum })

    containers = [
      {
        name  = "promtail"
        image = var.image
        args = [
          "-config.file=/etc/promtail/promtail.yaml",
          "-client.url=${var.loki_url}",
          "-client.tenant-id=${var.tenant_id}",
        ]
        env = concat([
          {
            name = "HOSTNAME"
            value_from = {
              field_ref = {
                field_path = "spec.nodeName"
              }
            }
          },
        ], var.env)

        resources = var.resources

        volume_mounts = [
          {
            name       = "varlog"
            mount_path = "/var/log"
          },
          {
            name       = "varlibdockercontainers"
            mount_path = "/var/lib/docker/containers"
            read_only  = true
          },
          {
            name       = "config"
            mount_path = "/etc/promtail"
          },
          {
            name       = "run"
            mount_path = "/run/promtail"
          },
        ]
      },
    ]
    service_account_name = module.rbac.service_account.metadata.0.name
    volumes = [
      {
        name = "varlog"
        host_path = {
          path = "/var/log"
        }
      },
      {
        name = "varlibdockercontainers"
        host_path = {
          path = "/var/lib/docker/containers"
        }
      },
      {
        name = "config"
        config_map = {
          name = module.config.name
        }
      },
      {
        name = "run"
        host_path = {
          path = "/run/promtail"
        }
      },
    ]
  }
}

module "config" {
  source    = "../../kubernetes/config-map"
  name      = var.name
  namespace = var.namespace
  from-map = {
    "promtail.yaml" = file(coalesce(var.config_file, "${path.module}/promtail.yaml"))
  }
}

module "daemonset" {
  source     = "../../../archetypes/daemonset"
  parameters = merge(local.parameters, var.overrides)
}