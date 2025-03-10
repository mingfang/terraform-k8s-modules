locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    annotations          = var.annotations
    replicas             = 1
    enable_service_links = false

    containers = [
      {
        name  = "k8s-sidecar"
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
            name  = "LABEL"
            value = var.LABEL
          },
          {
            name  = "LABEL_VALUE"
            value = var.LABEL_VALUE
          },
          {
            name  = "FOLDER"
            value = "/tmp/data"
          },
          {
            name  = "FOLDER_ANNOTATION"
            value = var.FOLDER_ANNOTATION
          },
          {
            name  = "NAMESPACE"
            value = var.NAMESPACE
          },
          {
            name  = "RESOURCE"
            value = var.RESOURCE
          },
          {
            name  = "METHOD"
            value = var.METHOD
          },
          {
            name  = "SLEEP_TIME"
            value = var.SLEEP_TIME
          },
          {
            name  = "REQ_URL"
            value = var.REQ_URL
          },
          {
            name  = "REQ_USERNAME"
            value = var.REQ_USERNAME
          },
          {
            name  = "REQ_METHOD"
            value = var.REQ_METHOD
          },
          {
            name  = "REQ_PAYLOAD"
            value = var.REQ_PAYLOAD
          },
          {
            name  = "REQ_PASSWORD"
            value = var.REQ_PASSWORD
          },
          {
            name  = "REQ_RETRY_TOTAL"
            value = var.REQ_RETRY_TOTAL
          },
          {
            name  = "REQ_RETRY_CONNECT"
            value = var.REQ_RETRY_CONNECT
          },
          {
            name  = "REQ_RETRY_READ"
            value = var.REQ_RETRY_READ
          },
          {
            name  = "REQ_RETRY_BACKOFF_FACTOR"
            value = var.REQ_RETRY_BACKOFF_FACTOR
          },
          {
            name  = "REQ_TIMEOUT"
            value = var.REQ_TIMEOUT
          },
          {
            name  = "SCRIPT"
            value = var.SCRIPT
          },
          {
            name  = "ERROR_THROTTLE_SLEEP"
            value = var.ERROR_THROTTLE_SLEEP
          },
          {
            name  = "SKIP_TLS_VERIFY"
            value = var.SKIP_TLS_VERIFY
          },
          {
            name  = "UNIQUE_FILENAMES"
            value = var.UNIQUE_FILENAMES
          },
          {
            name  = "DEFAULT_FILE_MODE"
            value = var.DEFAULT_FILE_MODE
          },
        ], var.env)

        resources = var.resources

        volume_mounts = var.pvc_name != null ? [
          {
            name       = "data"
            mount_path = "/tmp/data"
          },
        ] : []
      }
    ]

    init_containers = [
      {
        name  = "init"
        image = var.image
        command = [
          "sh",
          "-cx",
          "mkdir -p /tmp/data && chown -R nobody /tmp/data"
        ]

        security_context = {
          run_asuser = "0"
        }

        volume_mounts = var.pvc_name != null ? [
          {
            name       = "data"
            mount_path = "/tmp/data"
          },
        ] : []
      }
    ]

    service_account_name = module.rbac.service_account.metadata[0].name

    strategy = {
      type = "Recreate"
    }

    volumes = var.pvc_name != null ? [
      {
        name = "data"
        persistent_volume_claim = {
          claim_name = var.pvc_name
        }
      },
    ] : []
  }
}

module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
