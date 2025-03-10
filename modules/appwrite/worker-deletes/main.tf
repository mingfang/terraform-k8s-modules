locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    annotations          = var.annotations
    replicas             = var.replicas
    enable_service_links = false

    containers = [
      {
        name    = "worker-deletes"
        image   = var.image
        command = ["worker-deletes"]

        env = concat([
          { name = "_APP_ENV", value = var._APP_ENV },
          { name = "_APP_REDIS_HOST", value = var._APP_REDIS_HOST },
          { name = "_APP_REDIS_PORT", value = var._APP_REDIS_PORT },
          { name = "_APP_DB_HOST", value = var._APP_DB_HOST },
          { name = "_APP_DB_PORT", value = var._APP_DB_PORT },
          { name = "_APP_DB_SCHEMA", value = var._APP_DB_SCHEMA },
          { name = "_APP_DB_USER", value = var._APP_DB_USER },
          { name = "_APP_DB_PASS", value = var._APP_DB_PASS },
        ], var.env)

        volume_mounts = concat(
          var.pvc_uploads != null ? [
            {
              name       = "uploads"
              mount_path = "/storage/uploads"
            },
          ] : [],
        )
      }
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
    )
  }
}

module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
