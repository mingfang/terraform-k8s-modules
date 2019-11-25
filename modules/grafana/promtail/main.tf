/**
 * [Fluent Bit](https://fluentbit.io)
 *
 * FluentBit Runs as a daemonset sending logs directly to Elasticsearch
 */

locals {
  parameters = {
    name        = var.name
    namespace   = var.namespace
    // restart on config change
    annotations = merge(var.annotations, { checksum = md5(data.template_file.config.rendered) })

    containers = [
      {
        name  = "promtail"
        image = var.image
        args = [
          "-config.file=/etc/promtail/promtail.yaml",
          "-client.url=${var.loki_url}"
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
    tolerations = [
      {
        effect   = "NoSchedule"
        key      = "node-role.kubernetes.io/master"
        operator = "Exists"
      },
    ]
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
          name = k8s_core_v1_config_map.this.metadata.0.name
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

module "daemonset" {
  source     = "../../../archetypes/daemonset"
  parameters = merge(local.parameters, var.overrides)
}

module "rbac" {
  source = "../../../modules/kubernetes/rbac"
  name   = var.name
  namespace   = var.namespace
  cluster_role_rules = [
    {
      api_groups = [
        "",
      ]

      resources = [
        "endpoints",
        "namespaces",
        "nodes",
        "nodes/proxy",
        "pods",
        "services",
      ]

      verbs = [
        "get",
        "list",
        "watch",
      ]
    },
  ]
}