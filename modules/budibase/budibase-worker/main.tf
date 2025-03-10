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
        name  = "worker"
        image = var.image
        env = concat([
          { name = "SELF_HOSTED", value = var.SELF_HOSTED },
          { name = "COUCH_DB_USERNAME", value = var.COUCH_DB_USERNAME },
          { name = "COUCH_DB_PASSWORD", value = var.COUCH_DB_PASSWORD },
          { name = "COUCH_DB_URL", value = var.COUCH_DB_URL },
          { name = "MINIO_URL", value = var.MINIO_URL },
          { name = "MINIO_ACCESS_KEY", value = var.MINIO_ACCESS_KEY },
          { name = "MINIO_SECRET_KEY", value = var.MINIO_SECRET_KEY },
          { name = "INTERNAL_API_KEY", value = var.INTERNAL_API_KEY },
          #          { name = "CLUSTER_PORT", value = var.ports[0].port },
          { name = "PORT", value = var.ports[0].port },
          { name = "JWT_SECRET", value = var.JWT_SECRET },
          { name = "LOG_LEVEL", value = var.LOG_LEVEL },
          { name = "SENTRY_DSN", value = var.SENTRY_DSN },
          { name = "ENABLE_ANALYTICS", value = var.ENABLE_ANALYTICS },
          { name = "REDIS_URL", value = var.REDIS_URL },
          { name = "REDIS_PASSWORD", value = var.REDIS_PASSWORD },
          { name = "NODE_ENV", value = "production" },
        ], var.env)

        resources = var.resources
      },
    ]
  }
}

module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}