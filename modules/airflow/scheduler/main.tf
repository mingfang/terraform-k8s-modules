locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    annotations          = var.annotations
    replicas             = 1
    enable_service_links = false

    containers = [
      {
        name  = "scheduler"
        image = var.image
        command = ["airflow", "scheduler"]

        env = concat([
          {
            name = "AIRFLOW__CORE__SQL_ALCHEMY_CONN"
            value = var.AIRFLOW__CORE__SQL_ALCHEMY_CONN
          },
          {
            name = "AIRFLOW__CORE__EXECUTOR"
            value = "KubernetesExecutor"
          },
          {
            name = "AIRFLOW__KUBERNETES__WORKER_CONTAINER_REPOSITORY"
            value = split(":", var.image)[0]
          },
          {
            name = "AIRFLOW__KUBERNETES__WORKER_CONTAINER_TAG"
            value = split(":", var.image)[1]
          },
          {
            name = "AIRFLOW__KUBERNETES__RUN_AS_USER"
            value = 50000
          },
          {
            name = "AIRFLOW__KUBERNETES__NAMESPACE"
            value = var.namespace
          },
          {
            name = "AIRFLOW__KUBERNETES__DELETE_WORKER_PODS"
            value = "True"
          }
        ], var.env)

        volume_mounts = concat(
          var.pvc_dags != null ? [
            {
              name       = "dags"
              mount_path = "/opt/airflow/dags"
            },
          ] : [],
          var.pvc_logs != null ? [
            {
              name       = "logs"
              mount_path = "/opt/airflow/logs"
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
          chown airflow /opt/airflow/dags
          EOF
        ]
        security_context = {
          run_asuser  = "0"
        }
        volume_mounts = concat(
          var.pvc_dags != null ? [
            {
              name       = "dags"
              mount_path = "/opt/airflow/dags"
            },
          ] : [],
          var.pvc_logs != null ? [
            {
              name       = "logs"
              mount_path = "/opt/airflow/logs"
            },
          ] : [],
        )
      },
      {
        name  = "initdb"
        image = var.image
        command = ["airflow", "initdb"]

        env = [
          {
            name = "AIRFLOW__CORE__SQL_ALCHEMY_CONN"
            value = var.AIRFLOW__CORE__SQL_ALCHEMY_CONN
          },
        ]
      },
    ]

    service_account_name = module.rbac.name

    volumes = concat(
      var.pvc_dags != null ? [
        {
          name = "dags"
          persistent_volume_claim = {
            claim_name = var.pvc_dags
          }
        },
      ] : [],
      var.pvc_logs != null ? [
        {
          name = "logs"
          persistent_volume_claim = {
            claim_name = var.pvc_logs
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
