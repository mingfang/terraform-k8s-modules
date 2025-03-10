module "init-job" {
  source    = "../../kubernetes/job"
  name      = "${var.name}-init"
  namespace = var.namespace

  image   = var.bootloader_image
  command = null

  env = concat([
    {
      name  = "AIRBYTE_VERSION"
      value = local.AIRBYTE_VERSION
    },
    {
      name  = "RUN_DATABASE_MIGRATION_ON_STARTUP"
      value = "true"
    },
  ], local.computed_env)
}
