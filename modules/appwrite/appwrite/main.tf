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
        name  = "appwrite"
        image = var.image

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

        volume_mounts = concat(
          var.pvc_uploads != null ? [
            {
              name       = "uploads"
              mount_path = "/storage/uploads"
            },
          ] : [],
          var.pvc_functions != null ? [
            {
              name       = "functions"
              mount_path = "/storage/functions"
            },
          ] : [],
        )
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
          chown www-data:www-data /storage/uploads
          chown www-data:www-data /storage/functions
          EOF
        ]
        security_context = {
          run_asuser = "0"
        }
        volume_mounts = concat(
          var.pvc_uploads != null ? [
            {
              name       = "uploads"
              mount_path = "/storage/uploads"
            },
          ] : [],
          var.pvc_functions != null ? [
            {
              name       = "functions"
              mount_path = "/storage/functions"
            },
          ] : [],
        )
      },
    ]

    volumes = concat(
      var.pvc_uploads != null ? [
        {
          name = "uploads"
          persistent_volume_claim = {
            claim_name = var.pvc_uploads
          }
        },
      ] : [],
      var.pvc_functions != null ? [
        {
          name = "functions"
          persistent_volume_claim = {
            claim_name = var.pvc_functions
          }
        },
      ] : [],
    )
  }
}

module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
