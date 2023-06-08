locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    annotations          = var.annotations
    replicas             = var.replicas
    ports                = var.ports
    enable_service_links = false

    containers = concat([
      {
        name    = var.name
        image   = var.image
        command = var.command

        env = concat([
          { name = "_APP_ENV", value = var._APP_ENV },
          { name = "_APP_REDIS_HOST", value = var._APP_REDIS_HOST },
          { name = "_APP_REDIS_PORT", value = var._APP_REDIS_PORT },
          { name = "_APP_DB_HOST", value = var._APP_DB_HOST },
          { name = "_APP_DB_PORT", value = var._APP_DB_PORT },
          { name = "_APP_DB_SCHEMA", value = var._APP_DB_SCHEMA },
          { name = "_APP_DB_USER", value = var._APP_DB_USER },
          { name = "_APP_DB_PASS", value = var._APP_DB_PASS },
          { name = "_APP_USAGE_STATS", value = var._APP_USAGE_STATS },
          { name = "_APP_INFLUXDB_HOST", value = var._APP_INFLUXDB_HOST },
          { name = "_APP_INFLUXDB_PORT", value = var._APP_INFLUXDB_PORT },
          { name = "_APP_STORAGE_ANTIVIRUS", value = var._APP_STORAGE_ANTIVIRUS },
        ], var.env)

        volume_mounts = [
        for pvc in var.pvcs : {
          name       = pvc.metadata[0].name
          mount_path = "/storage/${pvc.metadata[0].name}"
        }
        ]
      }
    ], var.sidecars)

    init_containers = [
      {
        name    = "chown"
        image   = var.image
        command = [
          "sh",
          "-cx",
          <<-EOF
          chown www-data:www-data /storage/*
          EOF
        ]
        security_context = {
          run_asuser = "0"
        }

        volume_mounts = [
        for pvc in var.pvcs : {
          name       = pvc.metadata[0].name
          mount_path = "/storage/${pvc.metadata[0].name}"
        }
        ]
      },
    ]

    volumes = [
    for pvc in var.pvcs :
    {
      name = pvc.metadata[0].name

      persistent_volume_claim = {
        claim_name = pvc.metadata[0].name
      }
    }
    ]
  }
}

module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
