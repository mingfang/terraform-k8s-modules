resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

locals {
  _APP_ENV         = "development"
  _APP_USAGE_STATS = "enabled"
  _APP_DB_SCHEMA   = "appwrite"
  _APP_DB_USER     = "appwrite"
  _APP_DB_PASS     = "appwrite"
}

module "redis" {
  source    = "../../modules/redis"
  name      = "redis"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  replicas = 1
}

module "mariadb" {
  source        = "../../modules/mysql"
  name          = "mariadb"
  namespace     = k8s_core_v1_namespace.this.metadata[0].name
  storage_class = "cephfs"
  storage       = "1Gi"
  replicas      = 1

  image = "appwrite/mariadb:1.2.0"
  args = [
    "--innodb-flush-method=fsync",
  ]

  MYSQL_USER          = local._APP_DB_USER
  MYSQL_PASSWORD      = local._APP_DB_PASS
  MYSQL_ROOT_PASSWORD = local._APP_DB_PASS
  MYSQL_DATABASE      = local._APP_DB_SCHEMA
}

# volumes
resource "k8s_core_v1_persistent_volume_claim" "uploads" {
  metadata {
    name      = "uploads"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }

  spec {
    access_modes = ["ReadWriteMany"]
    resources { requests = { "storage" = "1Gi" } }
    storage_class_name = "cephfs"
  }
}

resource "k8s_core_v1_persistent_volume_claim" "functions" {
  metadata {
    name      = "functions"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }

  spec {
    access_modes = ["ReadWriteMany"]
    resources { requests = { "storage" = "1Gi" } }
    storage_class_name = "cephfs"
  }
}

module "appwrite" {
  source    = "../../modules/appwrite/appwrite"
  name      = "appwrite"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  pvc_uploads   = k8s_core_v1_persistent_volume_claim.uploads.metadata[0].name
  pvc_functions = k8s_core_v1_persistent_volume_claim.functions.metadata[0].name

  _APP_ENV           = local._APP_ENV
  _APP_USAGE_STATS   = local._APP_USAGE_STATS
  _APP_REDIS_HOST    = module.redis.name
  _APP_REDIS_PORT    = module.redis.ports[0].port
  _APP_DB_HOST       = module.mariadb.name
  _APP_DB_PORT       = module.mariadb.ports[0].port
  _APP_DB_SCHEMA     = local._APP_DB_SCHEMA
  _APP_DB_USER       = local._APP_DB_USER
  _APP_DB_PASS       = local._APP_DB_PASS
  _APP_INFLUXDB_HOST = module.influxdb.name
  _APP_INFLUXDB_PORT = module.influxdb.ports[0].port
}

module "realtime" {
  source    = "../../modules/appwrite/realtime"
  name      = "realtime"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  _APP_ENV         = local._APP_ENV
  _APP_USAGE_STATS = local._APP_USAGE_STATS
  _APP_REDIS_HOST  = module.redis.name
  _APP_REDIS_PORT  = module.redis.ports[0].port
  _APP_DB_HOST     = module.mariadb.name
  _APP_DB_PORT     = module.mariadb.ports[0].port
  _APP_DB_SCHEMA   = local._APP_DB_SCHEMA
  _APP_DB_USER     = local._APP_DB_USER
  _APP_DB_PASS     = local._APP_DB_PASS
}

module "worker-usage" {
  source    = "../../modules/appwrite/worker-usage"
  name      = "worker-usage"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  _APP_ENV         = local._APP_ENV
  _APP_REDIS_HOST  = module.redis.name
  _APP_REDIS_PORT  = module.redis.ports[0].port
  _APP_STATSD_HOST = module.telegraf.name
  _APP_STATSD_PORT = module.telegraf.ports[0].port
}

module "worker-audits" {
  source    = "../../modules/appwrite/worker-audits"
  name      = "worker-audits"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  _APP_ENV        = local._APP_ENV
  _APP_REDIS_HOST = module.redis.name
  _APP_REDIS_PORT = module.redis.ports[0].port
  _APP_DB_HOST    = module.mariadb.name
  _APP_DB_PORT    = module.mariadb.ports[0].port
  _APP_DB_SCHEMA  = local._APP_DB_SCHEMA
  _APP_DB_USER    = local._APP_DB_USER
  _APP_DB_PASS    = local._APP_DB_PASS
}

module "worker-webhook" {
  source    = "../../modules/appwrite/worker-webhook"
  name      = "webhook"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  _APP_ENV        = local._APP_ENV
  _APP_REDIS_HOST = module.redis.name
  _APP_REDIS_PORT = module.redis.ports[0].port
}

module "worker-tasks" {
  source    = "../../modules/appwrite/worker-tasks"
  name      = "worker-tasks"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  _APP_ENV        = local._APP_ENV
  _APP_REDIS_HOST = module.redis.name
  _APP_REDIS_PORT = module.redis.ports[0].port
  _APP_DB_HOST    = module.mariadb.name
  _APP_DB_PORT    = module.mariadb.ports[0].port
  _APP_DB_SCHEMA  = local._APP_DB_SCHEMA
  _APP_DB_USER    = local._APP_DB_USER
  _APP_DB_PASS    = local._APP_DB_PASS
}

module "worker-deletes" {
  source    = "../../modules/appwrite/worker-deletes"
  name      = "worker-deletes"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  pvc_uploads = k8s_core_v1_persistent_volume_claim.uploads.metadata[0].name

  _APP_ENV        = local._APP_ENV
  _APP_REDIS_HOST = module.redis.name
  _APP_REDIS_PORT = module.redis.ports[0].port
  _APP_DB_HOST    = module.mariadb.name
  _APP_DB_PORT    = module.mariadb.ports[0].port
  _APP_DB_SCHEMA  = local._APP_DB_SCHEMA
  _APP_DB_USER    = local._APP_DB_USER
  _APP_DB_PASS    = local._APP_DB_PASS
}

module "worker-functions" {
  source    = "../../modules/appwrite/worker-functions"
  name      = "worker-functions"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  pvc_functions = k8s_core_v1_persistent_volume_claim.functions.metadata[0].name

  _APP_ENV         = local._APP_ENV
  _APP_USAGE_STATS = local._APP_USAGE_STATS
  _APP_REDIS_HOST  = module.redis.name
  _APP_REDIS_PORT  = module.redis.ports[0].port
  _APP_DB_HOST     = module.mariadb.name
  _APP_DB_PORT     = module.mariadb.ports[0].port
  _APP_DB_SCHEMA   = local._APP_DB_SCHEMA
  _APP_DB_USER     = local._APP_DB_USER
  _APP_DB_PASS     = local._APP_DB_PASS
}

module "schedule" {
  source    = "../../modules/appwrite/schedule"
  name      = "schedule"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  _APP_ENV        = local._APP_ENV
  _APP_REDIS_HOST = module.redis.name
  _APP_REDIS_PORT = module.redis.ports[0].port
}

module "maintenance" {
  source    = "../../modules/appwrite/maintenance"
  name      = "maintenance"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  _APP_ENV        = local._APP_ENV
  _APP_REDIS_HOST = module.redis.name
  _APP_REDIS_PORT = module.redis.ports[0].port
}

module "influxdb" {
  source    = "../../modules/appwrite/influxdb"
  name      = "influxdb"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}

module "telegraf" {
  source    = "../../modules/appwrite/telegraf"
  name      = "telegraf"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  _APP_INFLUXDB_HOST = module.influxdb.name
  _APP_INFLUXDB_PORT = module.influxdb.ports[0].port
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "this" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"                    = "nginx"
      "nginx.ingress.kubernetes.io/server-alias"       = "appwrite-example.*"
      "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true"
      "nginx.ingress.kubernetes.io/proxy-body-size"    = "10240m"
    }
    name      = module.appwrite.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${var.name}.${var.namespace}"
      http {
        paths {
          path = "/"
          backend {
            service_name = module.appwrite.name
            service_port = module.appwrite.ports[0].port
          }
        }
        paths {
          path = "/v1/realtime"
          backend {
            service_name = module.realtime.name
            service_port = module.realtime.ports[0].port
          }
        }
      }
    }
  }
}


