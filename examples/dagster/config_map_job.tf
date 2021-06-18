module "config_map_job" {
  source    = "../../modules/kubernetes/config-map"
  name      = "${var.name}-job"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  from-map = {
    "dagster.yaml" = <<-EOF
      run_storage:
        module: dagster_postgres.run_storage
        class: PostgresRunStorage
        config:
          postgres_db:
            username:
              env: DAGSTER_PG_USER
            password:
              env: DAGSTER_PG_PASSWORD
            hostname:
              env: DAGSTER_PG_HOST
            db_name:
              env: DAGSTER_PG_DB
            port:
              env: DAGSTER_PG_PORT

      event_log_storage:
        module: dagster_postgres.event_log
        class: PostgresEventLogStorage
        config:
          postgres_db:
            username:
              env: DAGSTER_PG_USER
            password:
              env: DAGSTER_PG_PASSWORD
            hostname:
              env: DAGSTER_PG_HOST
            db_name:
              env: DAGSTER_PG_DB
            port:
              env: DAGSTER_PG_PORT
    EOF
  }
}