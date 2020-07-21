resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "postgres" {
  source        = "../../modules/postgres"
  name          = "postgres"
  namespace     = k8s_core_v1_namespace.this.metadata[0].name
  storage_class = var.storage_class_name
  storage       = "1Gi"
  replicas      = 1

  POSTGRES_USER     = "airflow"
  POSTGRES_PASSWORD = "airflow"
  POSTGRES_DB       = "airflow"
}

resource "k8s_core_v1_persistent_volume_claim" "dag" {
  metadata {
    name      = "dags"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }

  spec {
    access_modes = ["ReadWriteMany"]
    resources { requests = { "storage" = "1Gi" } }
    storage_class_name = var.storage_class_name
  }
}

resource "k8s_core_v1_persistent_volume_claim" "logs" {
  metadata {
    name      = "logs"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }

  spec {
    access_modes = ["ReadWriteMany"]
    resources { requests = { "storage" = "1Gi" } }
    storage_class_name = var.storage_class_name
  }
}

locals {
  AIRFLOW__CORE__SQL_ALCHEMY_CONN = "postgresql+psycopg2://airflow:airflow@${module.postgres.name}:5432/airflow"
  common_env = [
    {
      name  = "AIRFLOW__CORE__LOAD_EXAMPLES"
      value = "True"
    },
  ]
}

module "scheduler" {
  source    = "../../modules/airflow/scheduler"
  name      = "scheduler"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  env = concat(local.common_env, [
    {
      name  = "AIRFLOW__KUBERNETES__DAGS_IN_IMAGE"
      value = "False"
    },
    {
      name  = "AIRFLOW__KUBERNETES__DAGS_VOLUME_CLAIM"
      value = k8s_core_v1_persistent_volume_claim.dag.metadata[0].name
    },
    //    {
    //      name = "AIRFLOW__KUBERNETES__LOGS_VOLUME_CLAIM"
    //      value = k8s_core_v1_persistent_volume_claim.logs.metadata[0].name
    //    },
    {
      name  = "AIRFLOW__KUBERNETES__DELETE_WORKER_PODS"
      value = "False"
    },
  ])

  pvc_dags                        = k8s_core_v1_persistent_volume_claim.dag.metadata[0].name
  AIRFLOW__CORE__SQL_ALCHEMY_CONN = local.AIRFLOW__CORE__SQL_ALCHEMY_CONN
}

module "webserver" {
  source    = "../../modules/airflow/webserver"
  name      = "webserver"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  env = concat(local.common_env, [
    {
      name  = "AIRFLOW__WEBSERVER__EXPOSE_CONFIG"
      value = "True"
    },
    {
      name  = "AIRFLOW__CORE__SECURE_MODE"
      value = "False"
    },
    {
      name  = "AIRFLOW__WEBSERVER__RBAC"
      value = "False"
    },
  ])

  pvc_dags                        = k8s_core_v1_persistent_volume_claim.dag.metadata[0].name
  AIRFLOW__CORE__SQL_ALCHEMY_CONN = local.AIRFLOW__CORE__SQL_ALCHEMY_CONN
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "airflow" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "airflow-example.*"
    }
    name      = module.webserver.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${var.name}.${var.namespace}"
      http {
        paths {
          backend {
            service_name = module.webserver.name
            service_port = 8080
          }
          path = "/"
        }
      }
    }
  }
}

