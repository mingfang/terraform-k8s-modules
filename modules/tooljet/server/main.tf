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
        name    = "tooljet"
        image   = var.image
        command = ["npm", "run", "start:prod"]

        env = concat([
          { name = "SERVE_CLIENT", value = var.SERVE_CLIENT },
          { name = "PG_HOST", value = var.PG_HOST },
          { name = "PG_DB", value = var.PG_DB },
          { name = "PG_USER", value = var.PG_USER },
          { name = "PG_PASS", value = var.PG_PASS },
          { name = "LOCKBOX_MASTER_KEY", value = var.LOCKBOX_MASTER_KEY },
          { name = "SECRET_KEY_BASE", value = var.SECRET_KEY_BASE },
          { name = "TOOLJET_HOST", value = var.TOOLJET_HOST },
          { name = "CHECK_FOR_UPDATES", value = var.CHECK_FOR_UPDATES },
          { name = "COMMENT_FEATURE_ENABLE", value = var.COMMENT_FEATURE_ENABLE },
          { name = "DEPLOYMENT_PLATFORM", value = "k8s" },
          { name = "DISABLE_SIGNUPS", value = "true" },
        ], var.env)

        resources = var.resources
      },
    ]

    init_containers = [
      {
        name    = "init"
        image   = var.image
        command = ["sh", "-c", <<-EOF
        npm run db:create
        npm run db:migrate
        EOF
        ]

        env = concat([
          { name = "SERVE_CLIENT", value = var.SERVE_CLIENT },
          { name = "PG_HOST", value = var.PG_HOST },
          { name = "PG_DB", value = var.PG_DB },
          { name = "PG_USER", value = var.PG_USER },
          { name = "PG_PASS", value = var.PG_PASS },
          { name = "LOCKBOX_MASTER_KEY", value = var.LOCKBOX_MASTER_KEY },
          { name = "SECRET_KEY_BASE", value = var.SECRET_KEY_BASE },
          { name = "TOOLJET_HOST", value = var.TOOLJET_HOST },
          { name = "CHECK_FOR_UPDATES", value = var.CHECK_FOR_UPDATES },
          { name = "COMMENT_FEATURE_ENABLE", value = var.COMMENT_FEATURE_ENABLE },
          { name = "DEPLOYMENT_PLATFORM", value = "k8s" },
          { name = "DISABLE_SIGNUPS", value = "true" },
        ], var.env)
      },
    ]
  }
}

module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}