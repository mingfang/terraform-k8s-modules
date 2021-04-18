module "config_map_pipeline" {
  source    = "../../modules/kubernetes/config-map"
  name      = "${var.name}-pipeline"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  from-map = {
    "DAGSTER_PG_HOST"                = module.postgres.name
    "DAGSTER_PG_PORT"                = 5432
    "DAGSTER_PG_DB"                  = "dagster"
    "DAGSTER_PG_USER"                = "dagster"
    "DAGSTER_K8S_PG_PASSWORD_SECRET" = module.postgres_password.name

    "DAGSTER_K8S_INSTANCE_CONFIG_MAP"            = module.config_map_instance.name
    "DAGSTER_K8S_PIPELINE_RUN_ENV_CONFIGMAP"     = "${var.name}-pipeline"
    "DAGSTER_K8S_PIPELINE_RUN_IMAGE"             = "docker.io/dagster/user-code-example:latest"
    "DAGSTER_K8S_PIPELINE_RUN_IMAGE_PULL_POLICY" = "Always"
    "DAGSTER_K8S_PIPELINE_RUN_NAMESPACE"         = k8s_core_v1_namespace.this.metadata[0].name
  }
}