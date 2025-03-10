locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    annotations          = var.annotations
    replicas             = var.replicas
    enable_service_links = false

    containers = [
      {
        name    = "worker-functions"
        image   = var.image
        command = ["worker-functions"]

        env = concat([
          { name = "_APP_ENV", value = var._APP_ENV },
          { name = "_APP_REDIS_HOST", value = var._APP_REDIS_HOST },
          { name = "_APP_REDIS_PORT", value = var._APP_REDIS_PORT },
          { name = "_APP_DB_HOST", value = var._APP_DB_HOST },
          { name = "_APP_DB_PORT", value = var._APP_DB_PORT },
          { name = "_APP_DB_SCHEMA", value = var._APP_DB_SCHEMA },
          { name = "_APP_DB_USER", value = var._APP_DB_USER },
          { name = "_APP_DB_PASS", value = var._APP_DB_PASS },
          { name = "_APP_FUNCTIONS_TIMEOUT", value = var._APP_FUNCTIONS_TIMEOUT },
          { name = "_APP_FUNCTIONS_CONTAINERS", value = var._APP_FUNCTIONS_CONTAINERS },
          { name = "_APP_FUNCTIONS_CPUS", value = var._APP_FUNCTIONS_CPUS },
          { name = "_APP_FUNCTIONS_MEMORY", value = var._APP_FUNCTIONS_MEMORY },
          { name = "_APP_FUNCTIONS_MEMORY_SWAP", value = var._APP_FUNCTIONS_MEMORY_SWAP },
          { name = "_APP_USAGE_STATS", value = var._APP_USAGE_STATS },
        ], var.env)

        volume_mounts = concat([
          {
            name       = "docker"
            mount_path = "/var/run/docker.sock"
          },
          ],
          var.pvc_functions != null ? [
            {
              name       = "functions"
              mount_path = "/storage/functions"
            },
          ] : [],
        )
      }
    ]

    volumes = concat([
      {
        name = "docker"
        host_path = {
          path = "/var/run/docker.sock"
        }
      },
      ],
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
