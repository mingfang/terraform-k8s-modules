resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "minio" {
  source    = "../../modules/minio"
  name      = "minio"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  replicas           = 4
  storage            = "1Gi"
  storage_class_name = "cephfs"

  minio_access_key = var.minio_access_key
  minio_secret_key = var.minio_secret_key

  create_buckets = ["logs", "state"]
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "minio" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"                 = "nginx"
      "nginx.ingress.kubernetes.io/server-alias"    = "minio-${var.namespace}.*"
      "nginx.ingress.kubernetes.io/proxy-body-size" = "10240m"
    }
    name      = "minio"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "minio-${var.namespace}"
      http {
        paths {
          backend {
            service_name = module.minio.name
            service_port = module.minio.ports[1].port
          }
          path = "/"
        }
      }
    }
  }
}

module "postgres" {
  source    = "../../modules/postgres"
  name      = "postgres"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 1

  storage_class = "cephfs"
  storage       = "1Gi"

  env_map = {
    POSTGRES_USER     = "postgres"
    POSTGRES_PASSWORD = "postgres"
    POSTGRES_DB       = "postgres"
  }
}

module "temporal_config" {
  source    = "../../modules/kubernetes/config-map"
  name      = "temporal"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  from-file = "${path.module}/development.yaml"
}

module "airbyte-temporal" {
  source    = "../../modules/airbyte/airbyte-temporal"
  name      = "temporal"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  env_map = {
    DYNAMIC_CONFIG_FILE_PATH = "/etc/temporal/development.yaml"
    DB                       = "postgresql"
    POSTGRES_SEEDS           = module.postgres.name
    DB_PORT                  = module.postgres.ports[0].port
    POSTGRES_USER            = "postgres"
    POSTGRES_PWD             = "postgres"
    LOG_LEVEL                = "info"
  }

  configmap = module.temporal_config.config_map
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "temporal" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}-temporal.*"
    }
    name      = "temporal"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${var.namespace}-temporal"
      http {
        paths {
          backend {
            service_name = module.airbyte-temporal.name
            service_port = module.airbyte-temporal.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}

# https://github.com/airbytehq/airbyte/blob/master/airbyte-config/config-models/src/main/java/io/airbyte/config/EnvConfigs.java

locals {
  db_env = {
    CONFIG_DATABASE_USER     = "postgres"
    CONFIG_DATABASE_PASSWORD = "postgres"
    CONFIG_DATABASE_URL      = "jdbc:postgresql://${module.postgres.name}:${module.postgres.ports[0].port}/postgres"
    CONFIG_ROOT              = "/data"
    DATABASE_URL             = "jdbc:postgresql://${module.postgres.name}:${module.postgres.ports[0].port}/postgres"
    DATABASE_USER            = "postgres"
    DATABASE_PASSWORD        = "postgres"

    JOBS_DATABASE_MINIMUM_FLYWAY_MIGRATION_VERSION    = "0.29.15.001"
    CONFIGS_DATABASE_MINIMUM_FLYWAY_MIGRATION_VERSION = "0.35.15.001"
    RUN_DATABASE_MIGRATION_ON_STARTUP                 = "true"
  }

  log_env = {
    AWS_ACCESS_KEY_ID     = var.minio_access_key
    AWS_SECRET_ACCESS_KEY = var.minio_secret_key
    GCS_LOG_BUCKET        = ""
    S3_LOG_BUCKET         = "logs"
    S3_LOG_BUCKET_REGION  = ""
    S3_MINIO_ENDPOINT     = "http://${module.minio.name}:${module.minio.ports[0].port}"
    S3_PATH_STYLE_ACCESS  = "true"
  }

  kube_env = {
    CONTAINER_ORCHESTRATOR_ENABLED               = "true"
    CONNECTOR_SPECIFIC_RESOURCE_DEFAULTS_ENABLED = "true"
    JOB_KUBE_ANNOTATIONS                         = ""
    JOB_KUBE_MAIN_CONTAINER_IMAGE_PULL_POLICY    = "IfNotPresent"
    JOB_KUBE_MAIN_CONTAINER_IMAGE_PULL_SECRET    = ""
    JOB_KUBE_NAMESPACE                           = var.namespace
    JOB_KUBE_NODE_SELECTORS                      = ""
    JOB_KUBE_TOLERATIONS                         = ""
    JOB_MAIN_CONTAINER_CPU_REQUEST               = ""
    JOB_MAIN_CONTAINER_CPU_LIMIT                 = ""
    JOB_MAIN_CONTAINER_MEMORY_REQUEST            = ""
    JOB_MAIN_CONTAINER_MEMORY_LIMIT              = ""
    LOCAL_ROOT                                   = "/tmp/airbyte_local"
    TRACKING_STRATEGY                            = "segment"
    WORKER_ENVIRONMENT                           = "kubernetes"
    WORKSPACE_DOCKER_MOUNT                       = "airbyte_workspace"
    WORKSPACE_ROOT                               = "/tmp/workspace"
  }
}

resource "k8s_core_v1_persistent_volume_claim" "config" {
  metadata {
    name      = "config"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }

  spec {
    access_modes = ["ReadWriteMany"]
    resources { requests = { "storage" = "1Gi" } }
    storage_class_name = "cephfs"
  }
}

module "airbyte-server" {
  source    = "../../modules/airbyte/airbyte-server"
  name      = "server"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  env_map = merge({
    TEMPORAL_HOST      = "${module.airbyte-temporal.name}:${module.airbyte-temporal.ports[0].port}"
    WEBAPP_URL         = "https://${var.namespace}.rebelsoft.com"
    WORKER_ENVIRONMENT = "kubernetes"
    WORKSPACE_ROOT     = "/tmp/workspace"

  }, local.db_env, local.kube_env, local.log_env)

  pvc = k8s_core_v1_persistent_volume_claim.config.metadata[0].name
}

module "airbyte-worker" {
  source    = "../../modules/airbyte/airbyte-worker"
  name      = "worker"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  env_map = merge({
    INTERNAL_API_HOST                     = "${module.airbyte-server.name}:${module.airbyte-server.ports[0].port}"
    STATE_STORAGE_MINIO_ACCESS_KEY        = var.minio_access_key
    STATE_STORAGE_MINIO_SECRET_ACCESS_KEY = var.minio_secret_key
    STATE_STORAGE_MINIO_BUCKET_NAME       = "state"
    STATE_STORAGE_MINIO_ENDPOINT          = "http://${module.minio.name}:${module.minio.ports[0].port}"
    TEMPORAL_HOST                         = "${module.airbyte-temporal.name}:${module.airbyte-temporal.ports[0].port}"
    TEMPORAL_WORKER_PORTS                 = "9001,9002,9003,9004,9005,9006,9007,9008,9009,9010,9011,9012,9013,9014,9015,9016,9017,9018,9019,9020,9021,9022,9023,9024,9025,9026,9027,9028,9029,9030,9031,9032,9033,9034,9035,9036,9037,9038,9039,9040"
    WEBAPP_URL                            = "https://${var.namespace}.rebelsoft.com"
  }, local.db_env, local.kube_env, local.log_env)
}

module "airbyte-webapp" {
  source    = "../../modules/airbyte/airbyte-webapp"
  name      = "webapp"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  env_map = {
    FULLSTORY           = ""
    INTERNAL_API_HOST   = "${module.airbyte-server.name}:${module.airbyte-server.ports[0].port}"
    IS_DEMO             = ""
    OPENREPLAY          = ""
    PAPERCUPS_STORYTIME = ""
    TRACKING_STRATEGY   = "segment"
  }
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "webapp" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}.*"
    }
    name      = module.airbyte-webapp.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = var.namespace
      http {
        paths {
          backend {
            service_name = module.airbyte-webapp.name
            service_port = module.airbyte-webapp.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}

