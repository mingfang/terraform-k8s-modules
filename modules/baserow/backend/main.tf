locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    annotations          = var.annotations
    ports                = var.ports
    replicas             = var.replicas
    enable_service_links = false

    containers = [
      {
        name  = "backend"
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
            name  = "PRIVATE_BACKEND_URL"
            value = "http://${var.name}:${var.ports[0].port}"
          },
          {
            name  = "PUBLIC_BACKEND_URL"
            value = var.PUBLIC_BACKEND_URL
          },
          {
            name  = "PUBLIC_WEB_FRONTEND_URL"
            value = var.PUBLIC_WEB_FRONTEND_URL
          },
          {
            name  = "MEDIA_URL"
            value = var.MEDIA_URL
          },
          {
            name  = "REDIS_HOST"
            value = var.REDIS_HOST
          },
          {
            name  = "REDIS_PORT"
            value = var.REDIS_PORT
          },
          {
            name  = "REDIS_USER"
            value = var.REDIS_USER
          },
          {
            name  = "REDIS_PASSWORD"
            value = var.REDIS_PASSWORD
          },
          {
            name  = "REDIS_PROTOCOL"
            value = var.REDIS_PROTOCOL
          },
          {
            name  = "DATABASE_NAME"
            value = var.DATABASE_NAME
          },
          {
            name  = "DATABASE_USER"
            value = var.DATABASE_USER
          },
          {
            name  = "DATABASE_PASSWORD"
            value = var.DATABASE_PASSWORD
          },
          {
            name  = "DATABASE_HOST"
            value = var.DATABASE_HOST
          },
          {
            name  = "DATABASE_PORT"
            value = var.DATABASE_PORT
          },
          {
            name  = "MIGRATE_ON_STARTUP"
            value = var.MIGRATE_ON_STARTUP
          },
          {
            name  = "SYNC_TEMPLATES_ON_STARTUP"
            value = var.SYNC_TEMPLATES_ON_STARTUP
          },
        ], var.env)

        volume_mounts = var.pvc_media != null ? [
          {
            name       = "media"
            mount_path = "/baserow/media"
          },
        ] : []
      }
    ]

    init_containers = [
      {
        name  = "chown"
        image = var.image
        command = [
          "sh",
          "-cx",
          <<-EOF
          chown baserow_docker_user /baserow/media
          EOF
        ]
        security_context = {
          run_asuser = "0"
        }
        volume_mounts = var.pvc_media != null ? [
          {
            name       = "media"
            mount_path = "/baserow/media"
          },
        ] : []
      },
    ]

    volumes = var.pvc_media != null ? [
      {
        name = "media"
        persistent_volume_claim = {
          claim_name = var.pvc_media
        }
      },
    ] : []
  }
}

module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
