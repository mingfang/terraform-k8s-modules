/**
 * Documentation
 *
 * terraform-docs --sort-inputs-by-required --with-aggregate-type-defaults md
 *
 */

locals {
  parameters = {
    name                        = var.name
    namespace                   = var.namespace
    annotations                 = var.annotations
    replicas                    = var.replicas
    ports                       = var.ports
    enable_service_links        = false
    publish_not_ready_addresses = true
    pod_management_policy       = "Parallel"

    containers = [
      {
        name  = "zeebe"
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
            name  = "ZEEBE_HOST"
            value = "$(POD_NAME).${var.name}.${var.namespace}.svc.cluster.local"
          },
          {
            name  = "ZEEBE_CONTACT_POINTS"
            value = join(",", data.template_file.contact-points.*.rendered)
          },
          {
            name  = "ZEEBE_DIRECTORIES"
            value = "/data/$(POD_NAME)"
          },
          {
            name  = "ZEEBE_PARTITIONS_COUNT"
            value = 3
          },
          {
            name  = "ZEEBE_CLUSTER_SIZE"
            value = var.replicas
          },
          {
            name  = "ZEEBE_REPLICATION_FACTOR"
            value = 3
          },
          {
            name  = "JAVA_TOOL_OPTIONS"
            value = var.JAVA_TOOL_OPTIONS
          },
          {
            name  = "ZEEBE_LOG_LEVEL"
            value = var.ZEEBE_LOG_LEVEL
          },
        ], var.env)

        command = [
          "bash",
          "-cx",
          <<-EOF
          configFile=/usr/local/zeebe/conf/zeebe.cfg.toml
          export ZEEBE_NODE_ID="$${HOSTNAME##*-}"
          exec /usr/local/zeebe/bin/broker
          EOF
        ]

        readiness_probe = {
          initial_delay_seconds = 10
          http_get = {
            path = "/ready"
            port = 9600
          }
        }

        resources = {
          requests = {
            cpu    = "500m"
            memory = "1Gi"
          }
        }

        volume_mounts = [
          {
            mount_path = "/usr/local/zeebe/conf/zeebe.cfg.toml"
            name       = "config"
            sub_path   = "zeebe.cfg.toml"
          },
          {
            name       = var.volume_claim_template_name
            mount_path = "/data"
            sub_path   = var.name
          },
        ]
      },
    ]

    volumes = [
      {
        config_map = {
          name = k8s_core_v1_config_map.this.metadata[0].name
        }
        name = "config"
      },
    ]

    volume_claim_templates = [
      {
        name               = var.volume_claim_template_name
        storage_class_name = var.storage_class
        access_modes       = ["ReadWriteOnce"]

        resources = {
          requests = {
            storage = var.storage
          }
        }
      }
    ]
  }
}

module "statefulset-service" {
  source     = "git::https://github.com/mingfang/terraform-k8s-modules.git//archetypes/statefulset-service"
  parameters = merge(local.parameters, var.overrides)
}

data "template_file" "contact-points" {
  count    = var.replicas
  template = "${var.name}-${count.index}.${var.name}.${var.namespace}.svc.cluster.local:26502"
}