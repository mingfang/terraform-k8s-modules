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
    name        = var.name
    namespace   = var.namespace
    annotations = var.annotations
    containers = [
      {
        name  = "fluent-bit"
        image = var.image
        env = concat([
          {
            name  = "FLUENT_ELASTICSEARCH_HOST"
            value = var.fluent_elasticsearch_host
          },
          {
            name  = "FLUENT_ELASTICSEARCH_PORT"
            value = var.fluent_elasticsearch_port
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
            name       = "fluent-bit-config"
            mount_path = "/fluent-bit/etc/"
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
        name = "fluent-bit-config"
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

module "rbac" {
  source = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/kubernetes/rbac"
  name   = var.name
  cluster_role_rules = [
    {
      api_groups = [
        "",
      ]

      resources = [
        "namespaces",
        "pods",
      ]

      verbs = [
        "get",
        "list",
        "watch",
      ]
    },
  ]
}