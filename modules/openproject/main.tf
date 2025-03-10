

locals {
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
      name  = "DATABASE_URL"
      value = var.DATABASE_URL
    },
    {
      name  = "USE_PUMA"
      value = var.USE_PUMA
    },
    {
      name  = "IMAP_ENABLED"
      value = var.IMAP_ENABLED
    },
    {
      name  = "RAILS_CACHE_STORE"
      value = var.RAILS_CACHE_STORE
    },
    {
      name  = "OPENPROJECT_CACHE__MEMCACHE__SERVER"
      value = var.OPENPROJECT_CACHE__MEMCACHE__SERVER
    },
    {
      name  = "OPENPROJECT_RAILS__RELATIVE__URL__ROOT"
      value = var.OPENPROJECT_RAILS__RELATIVE__URL__ROOT
    },
  ], var.env)

  parameters = {
    name                 = var.name
    namespace            = var.namespace
    annotations          = var.annotations
    replicas             = var.replicas
    ports                = var.ports
    enable_service_links = false

    containers = [
      {
        name    = "openproject"
        image   = var.image
        command = ["/app/docker/prod/web"]
        env     = local.env

        volume_mounts = [
          {
            name       = "data"
            mount_path = "/var/openproject/assets"
          },
        ]
      },
      {
        name    = "worker"
        image   = var.image
        command = ["/app/docker/prod/worker"]
        env     = local.env
        volume_mounts = [
          {
            name       = "data"
            mount_path = "/var/openproject/assets"
          },
        ]
      },
      {
        name    = "cron"
        image   = var.image
        command = ["/app/docker/prod/cron"]
        env     = local.env
      },
    ]

    init_containers = [
      {
        name    = "seeder"
        image   = var.image
        command = ["/app/docker/prod/seeder"]
        env     = local.env
      },
    ]

    volumes = [
      {
        name = "data"
        persistent_volume_claim = {
          claim_name = var.pvc_name
        },
      }
    ]
  }
}

module "deployment-service" {
  source     = "../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
