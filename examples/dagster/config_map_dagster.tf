module "config_map_dagster" {
  source    = "../../modules/kubernetes/config-map"
  name      = "${var.name}-dagster"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  from-map = {
    "dagster.yaml" = <<-EOF
    scheduler:
      module: dagster.core.scheduler
      class: DagsterDaemonScheduler

    schedule_storage:
      module: dagster_postgres.schedule_storage
      class: PostgresScheduleStorage
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

    run_coordinator:
      module: dagster.core.run_coordinator
      class: QueuedRunCoordinator
      config:
        max_concurrent_runs: 25

    run_launcher:
      module: dagster_k8s.launcher
      class: K8sRunLauncher
      config:
        load_incluster_config: true
        dagster_home:
          env: DAGSTER_HOME
        postgres_password_secret:
          env: DAGSTER_K8S_PG_PASSWORD_SECRET
        job_namespace:
          env: DAGSTER_K8S_JOB_NAMESPACE
        service_account_name:
          env: DAGSTER_K8S_JOB_SERVICE_ACCOUNT
        instance_config_map:
          env: DAGSTER_K8S_JOB_CONFIG_MAP
        env_config_maps:
          - env: DAGSTER_K8S_JOB_ENV_CONFIGMAP
        env_vars:
          - DAGSTER_PG_HOST
          - DAGSTER_PG_PORT
          - DAGSTER_PG_DB
          - DAGSTER_PG_USER
          - DAGSTER_K8S_PG_PASSWORD_SECRET
          - DAGSTER_K8S_JOB_NAMESPACE
          - DAGSTER_K8S_JOB_SERVICE_ACCOUNT
          - DAGSTER_K8S_JOB_CONFIG_MAP
          - DAGSTER_K8S_JOB_ENV_CONFIGMAP

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