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
        name  = "jira"
        image = var.image

        env = concat(
          [
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
          ],
          var.pvc_shared != null ? [
            {
              name  = "CLUSTERED"
              value = "true"
            },
            {
              name  = "JIRA_NODE_ID"
              value = "$(POD_NAME)"
            },
            {
              name  = "JIRA_SHARED_HOME"
              value = "/var/atlassian/application-data/jira/shared"
            },
          ] : [],
        var.env)

        resources = var.resources

        volume_mounts = concat(
          [
            {
              name       = var.volume_claim_template_name
              mount_path = "/var/atlassian/application-data/jira"
            },
          ],
          var.pvc_shared != null ? [
            {
              name       = "shared"
              mount_path = "/var/atlassian/application-data/jira/shared"
            },
          ] : [],
        )
      },
    ]

    init_containers = var.pvc_shared != null ? [
      {
        name  = "chown"
        image = var.image
        command = [
          "sh",
          "-cx",
          <<-EOF
          chown jira:jira /var/atlassian/application-data/jira/shared
          EOF
        ]
        security_context = {
          run_asuser = "0"
        }
        volume_mounts = [
          {
            name       = "shared"
            mount_path = "/var/atlassian/application-data/jira/shared"
          },
        ]
      },
    ] : []

    volumes = var.pvc_shared != null ? [
      {
        name = "shared"
        persistent_volume_claim = {
          claim_name = var.pvc_shared
        }
      },
    ] : []

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
  source     = "../../archetypes/statefulset-service"
  parameters = merge(local.parameters, var.overrides)
}