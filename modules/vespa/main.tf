locals {
  input_env = merge(
    var.env_file != null ? {for tuple in regexall("(\\w+)=(.+)", file(var.env_file)) : tuple[0] => tuple[1]} : {},
    var.env_map,
  )
  computed_env = [for k, v in local.input_env : { name = k, value = v }]
}

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

    enable_service_links        = false
    pod_management_policy       = "Parallel"
    publish_not_ready_addresses = true

    containers = [
      {
        name  = var.name
        image = var.image
        command = [
          "bash",
          "-c",
          <<-EOF
          if [ "$(expr $${HOSTNAME//[^0-9]/})" -eq "0" ]; then
            /opt/vespa/bin/vespa-start-configserver
          fi

          /opt/vespa/bin/vespa-start-services

          tail -F /opt/vespa/logs/vespa/*.log
          EOF
        ]
        args = var.args

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
          {
            name = "VESPA_CONFIGSERVERS"
            value = "${var.name}-0.${var.name}.${var.namespace}.svc.cluster.local"
          },
          {
            name = "VESPA_HOSTNAME"
            value = "$(POD_NAME).${var.name}.${var.namespace}.svc.cluster.local"
          },
          {
            name = "VESPA_WEB_SERVICE_PORT"
            value = var.ports[0].port
          },
        ], var.env, local.computed_env)

        readiness_probe = {
#          http_get = {
#            path = "/ApplicationStatus"
#            port = var.ports[1].port
#            scheme = "HTTP"
#          }
        }

        resources = var.resources
        security_context = {
          privileged = true
        }

        volume_mounts = concat(
          var.storage != null ? [
            {
              name       = var.volume_claim_template_name
              mount_path = var.mount_path
            },
          ] : [],
          var.configmap != null ? [
          for k, v in var.configmap.data :
          {
            name       = "config"
            mount_path = "/config/${var.name}/${k}"
            sub_path   = k
          }
          ] : [],
          [], //hack: without this, sub_path above stops working
        )
      },
    ]

    init_containers = var.storage != null ? [
      {
        name    = "init"
        image   = var.image

        command = [
          "sh",
          "-cx",
          "chown 1000 ${var.mount_path}"
        ]

        security_context = {
          run_asuser = "0"
        }

        volume_mounts = [
          {
            name       = var.volume_claim_template_name
            mount_path = var.mount_path
          },
        ]
      }
    ] : []

    node_selector = var.node_selector
    service_account_name = var.service_account_name

    volumes = var.configmap != null ? [
        {
          name = "config"

          config_map = {
            name = var.configmap.metadata[0].name
          }
        }
      ] : []

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
  source     = "../../archetypes/statefulset-service"
  parameters = merge(local.parameters, var.overrides)
}