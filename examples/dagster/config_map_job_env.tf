module "config_map_job_env" {
  source    = "../../modules/kubernetes/config-map"
  name      = "${var.name}-job-env"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  from-map = {
    "DAGSTER_PG_HOST" = module.postgres.name
    "DAGSTER_PG_PORT" = 5432
    "DAGSTER_PG_DB"   = "dagster"
    "DAGSTER_PG_USER" = "dagster"
  }
}