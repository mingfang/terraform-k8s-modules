resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "clickhose" {
  source        = "../../modules/clickhouse"
  name          = "clickhouse"
  namespace     = k8s_core_v1_namespace.this.metadata[0].name
  replicas      = 1
  storage_class = "cephfs"
  storage       = "1Gi"
}

module "symbolicator" {
  source    = "../../modules/sentry/symbolicator"
  name      = "symbolicator"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}

module "zookeeper" {
  source        = "../../modules/zookeeper"
  name          = "zookeeper"
  namespace     = k8s_core_v1_namespace.this.metadata[0].name
  replicas      = 3
  storage_class = "cephfs"
  storage       = "1Gi"
}

module "kafka" {
  source        = "../../modules/kafka"
  name          = "kafka"
  namespace     = k8s_core_v1_namespace.this.metadata[0].name
  replicas      = 3
  storage_class = "cephfs"
  storage       = "1Gi"

  kafka_zookeeper_connect = "${module.zookeeper.name}:2181"
}

module "snuba" {
  source    = "../../modules/sentry/snuba"
  name      = "snuba"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  CLICKHOUSE_HOST = module.clickhose.name
  DEFAULT_BROKERS = "${module.kafka.name}:9092"
  REDIS_HOST      = module.redis.name
}

module "postgres" {
  source        = "../../modules/postgres"
  name          = "postgres"
  namespace     = k8s_core_v1_namespace.this.metadata[0].name
  replicas      = 1
  storage_class = "cephfs"
  storage       = "1Gi"

  POSTGRES_DB       = "sentry"
  POSTGRES_USER     = "sentry"
  POSTGRES_PASSWORD = "sentry"
}

module "redis" {
  source    = "../../modules/redis"
  name      = "redis"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}
module "memcached" {
  source    = "../../modules/memcached"
  name      = "memcached"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}

module "etc_configmap" {
  source    = "../../modules/sentry/config"
  name      = "etc-configmap"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}

module "env_configmap" {
  source    = "../../modules/kubernetes/config-map"
  name      = "env-configmap"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  from-map = {
    SENTRY_SECRET_KEY           = "secret123456789123456789123456789"
    SENTRY_REDIS_HOST           = module.redis.name
    SENTRY_REDIS_PORT           = "6379"
    SENTRY_MEMCACHED_HOST       = module.memcached.name
    SENTRY_MEMCACHED_PORT       = "11211"
    SENTRY_POSTGRES_HOST        = module.postgres.name
    SENTRY_POSTGRES_PORT        = "5432"
    SENTRY_DB_NAME              = "sentry"
    SENTRY_DB_USER              = "sentry"
    SENTRY_DB_PASSWORD          = "sentry"
    SENTRY_USE_SSL              = "False"
    SENTRY_EMAIL_HOST           = "postal-smtp-relay"
    SENTRY_EMAIL_PORT           = "25"
    SENTRY_EMAIL_USER           = "sentry"
    SENTRY_SERVER_EMAIL         = "email@example.com"
    SENTRY_EVENT_RETENTION_DAYS = "365"
    SENTRY_KAFKA_HOST_PORT      = "${module.kafka.name}:9092"
    SNUBA                       = "http://snuba:1218"
  }
}

module "sentry" {
  source         = "../../modules/sentry/sentry"
  name           = var.name
  namespace      = k8s_core_v1_namespace.this.metadata[0].name
  env_config_map = module.env_configmap.config_map.metadata[0].name
  etc_config_map = module.etc_configmap.config_map.metadata[0].name
}

module "cron" {
  source         = "../../modules/sentry/cron"
  name           = "cron"
  namespace      = k8s_core_v1_namespace.this.metadata[0].name
  env_config_map = module.env_configmap.config_map.metadata[0].name
  etc_config_map = module.etc_configmap.config_map.metadata[0].name
}

module "worker" {
  source         = "../../modules/sentry/worker"
  name           = "worker"
  namespace      = k8s_core_v1_namespace.this.metadata[0].name
  env_config_map = module.env_configmap.config_map.metadata[0].name
  etc_config_map = module.etc_configmap.config_map.metadata[0].name
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "this" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "sentry.*"
    }
    name      = module.sentry.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = module.sentry.name
      http {
        paths {
          backend {
            service_name = module.sentry.name
            service_port = 9000
          }
          path = "/"
        }
      }
    }
  }
}

