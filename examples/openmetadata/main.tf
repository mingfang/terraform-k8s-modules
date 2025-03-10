resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "postgres" {
  source    = "../../modules/postgres"
  name      = "postgres"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  storage_class = "cephfs"
  storage       = "1Gi"

  image = "registry.rebelsoft.com/postgres:16"

  args = [
    "-c", "work_mem=256MB",
    "-c", "maintenance_work_mem=256MB",
    "-c", "max_wal_size=1GB",
    "-c", "wal_level=logical",
  ]

  env_map = {
    POSTGRES_USER     = "postgres"
    POSTGRES_PASSWORD = "postgres"
    POSTGRES_DB       = "postgres"
  }
}

resource "k8s_core_v1_persistent_volume_claim" "ingestion" {
  metadata {
    name      = "ingestion"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }

  spec {
    access_modes       = ["ReadWriteOnce"]
    resources { requests = { "storage" = "1Gi" } }
    storage_class_name = "cephfs"
  }
}

module "ingestion" {
  source    = "../../modules/openmetadata/ingestion"
  name      = "ingestion"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  env_map = {
    "DB_HOST"                                                   = module.postgres.name
    "DB_PORT"                                                   = module.postgres.ports[0].port
    "DB_SCHEME"                                                 = "postgresql+psycopg2"
    "DB_USER"                                                   = "postgres"
    "DB_PASSWORD"                                               = "postgres"
    "AIRFLOW_DB"                                                = "postgres"
    "AIRFLOW__API__AUTH_BACKENDS"                               = "airflow.api.auth.backend.basic_auth,airflow.api.auth.backend.session"
    "AIRFLOW__CORE__EXECUTOR"                                   = "LocalExecutor"
    "AIRFLOW__OPENMETADATA_AIRFLOW_APIS__DAG_GENERATED_CONFIGS" = "/opt/airflow/dags"
  }

  pvcs = [
    {
      name       = k8s_core_v1_persistent_volume_claim.ingestion.metadata[0].name
      mount_path = "/opt/airflow/dags"
    }
  ]

  pvc_user = "airflow"
}

module "elasticsearch" {
  source    = "../../modules/elasticsearch"
  name      = "elasticsearch"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 1

  resources = {
    requests = {
      cpu    = "250m"
      memory = "1Gi"
    }
    limits = {
      memory = "2Gi"
    }
  }

  storage_class = "cephfs"
  storage       = "1Gi"

  env_map = {
    "discovery.type"               = "single-node"
    "cluster.initial_master_nodes" = ""
  }
}

module "server" {
  source    = "../../modules/openmetadata/server"
  name      = "server"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  env_map = {
    "DB_HOST"                               = module.postgres.name
    "DB_PORT"                               = module.postgres.ports[0].port
    "DB_DRIVER_CLASS"                       = "org.postgresql.Driver"
    "DB_SCHEME"                             = "postgresql"
    "DB_USE_SSL"                            = "false"
    "DB_USER"                               = "postgres"
    "DB_USER_PASSWORD"                      = "postgres"
    "OM_DATABASE"                           = "postgres"
    "SERVER_HOST_API_URL"                   = "http://server:8585/api"
    "PIPELINE_SERVICE_CLIENT_ENDPOINT"      = "http://${module.ingestion.name}:${module.ingestion.ports[0].port}"
    "AIRFLOW_USERNAME"                      = "admin"
    "AIRFLOW_PASSWORD"                      = "admin"
    "ELASTICSEARCH_HOST"                    = module.elasticsearch.name
    "ELASTICSEARCH_PORT"                    = module.elasticsearch.ports[0].port
    "ELASTICSEARCH_SCHEME"                  = "http"
    "ELASTICSEARCH_CONNECTION_TIMEOUT_SECS" = "5"
    "ELASTICSEARCH_SOCKET_TIMEOUT_SECS"     = "60"
    "ELASTICSEARCH_KEEP_ALIVE_TIMEOUT_SECS" = "600"
    "ELASTICSEARCH_BATCH_SIZE"              = "10"
  }
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "this" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}.*"
      "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
    }
    name      = var.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = var.namespace
      http {
        paths {
          backend {
            service_name = module.server.name
            service_port = module.server.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}
resource "k8s_networking_k8s_io_v1beta1_ingress" "ingestion" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}-ingestion.*"
      "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
    }
    name      = "${var.namespace}-ingestion"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${var.namespace}-ingestion"
      http {
        paths {
          backend {
            service_name = module.ingestion.name
            service_port = module.ingestion.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}
