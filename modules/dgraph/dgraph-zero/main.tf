/**
 * Documentation
 *
 * terraform-docs --sort-inputs-by-required --with-aggregate-type-defaults md
 *
 */

locals {
  peer = "${var.name}-0.${var.name}.${var.namespace}.svc.cluster.local:5080"

  parameters = {
    name                        = var.name
    namespace                   = var.namespace
    replicas                    = var.replicas
    ports                       = var.ports
    enable_service_links        = false
    publish_not_ready_addresses = true

    containers = [
      {
        name  = "zero"
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
            name = "POD_NAMESPACE"

            value_from = {
              field_ref = {
                field_path = "metadata.namespace"
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

        command = [
          "bash",
          "-cx",
          <<-EOF
          [[ `hostname` =~ -([0-9]+)$ ]] || exit 1
          ordinal=$${BASH_REMATCH[1]}
          idx=$(($ordinal + 1))
          if [[ $ordinal -eq 0 ]]; then
            exec dgraph zero --my=$(hostname -f):5080 --idx $idx --replicas 3
          else
            exec dgraph zero --my=$(hostname -f):5080 --peer ${local.peer} --idx $idx --replicas 3
          fi
          EOF
        ]

        liveness_probe = {
          initial_delay_seconds = 15
          period_seconds        = 10
          timeout_seconds       = 5
          failure_threshold     = 6
          success_threshold     = 1

          http_get = {
            path   = "/health"
            port   = 6080
            scheme = "HTTP"
          }
        }

        readiness_probe = {
          initial_delay_seconds = 15
          period_seconds        = 10
          timeout_seconds       = 5
          failure_threshold     = 6
          success_threshold     = 1

          http_get = {
            path   = "/state"
            port   = 6080
            scheme = "HTTP"
          }
        }

        volume_mounts = var.storage != null ? [
          {
            name          = var.volume_claim_template_name
            mount_path    = "/dgraph"
            sub_path_expr = "${var.name}/$(POD_NAME)"
          }
        ] : []
      },
    ]

    volume_claim_templates = var.storage != null ? [
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
    ] : []
  }
}

module "statefulset-service" {
  source     = "../../../archetypes/statefulset-service"
  parameters = merge(local.parameters, var.overrides)
}