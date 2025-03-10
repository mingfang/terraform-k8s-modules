resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "redis-cache" {
  source    = "../../modules/redis"
  name      = "redis-cache"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}

module "redis-queue" {
  source    = "../../modules/redis"
  name      = "redis-queue"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}

module "redis-socketio" {
  source    = "../../modules/redis"
  name      = "redis-socketio"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}

module "mysql" {
  source        = "../../modules/mysql"
  name          = "mysql"
  namespace     = k8s_core_v1_namespace.this.metadata[0].name
  storage_class = var.storage_class_name
  storage       = "1Gi"
  replicas      = 1

  MYSQL_USER          = "frappe"
  MYSQL_PASSWORD      = "frappe"
  MYSQL_ROOT_PASSWORD = "frappe"
  MYSQL_DATABASE      = "frappe"
  image               = "mariadb:latest"
  args = [
    "--character-set-client-handshake=FALSE",
    "--character-set-server=utf8mb4",
    "--collation-server=utf8mb4_unicode_ci"
  ]
}

/*
module "postgres" {
  source    = "../../modules/postgres"
  name      = "postgres"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  replicas      = 1
  storage       = "1Gi"
  storage_class = "cephfs"

  env_map = {
    POSTGRES_USER     = "frappe"
    POSTGRES_PASSWORD = "frappe"
    POSTGRES_DB       = "frappe"
  }
}
*/

locals {
  env = [
    {
      name  = "MARIADB_HOST"
      value = module.mysql.name
    },
    {
      name  = "DB_PORT"
      value = module.mysql.ports[0].port
    },
    {
      name  = "DB_ROOT_USER"
      value = "root"
    },
    {
      name  = "MYSQL_ROOT_PASSWORD"
      value = "frappe"
    },
    {
      name  = "REDIS_CACHE"
      value = "${module.redis-cache.name}:${module.redis-cache.ports[0].port}"
    },
    {
      name  = "REDIS_QUEUE"
      value = "${module.redis-queue.name}:${module.redis-queue.ports[0].port}"
    },
    {
      name  = "REDIS_SOCKETIO"
      value = "${module.redis-socketio.name}:${module.redis-socketio.ports[0].port}"
    },
    {
      name  = "SOCKETIO_PORT"
      value = 443
    },
  ]
}
/*

resource "k8s_core_v1_persistent_volume_claim" "sites" {
  metadata {
    name      = "sites"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }

  spec {
    access_modes = ["ReadWriteMany"]
    resources {
      requests = {
        "storage" = "1Gi"
      }
    }
    storage_class_name = var.storage_class_name
  }
}

module "server" {
  source    = "../../modules/frappe/server"
  name      = "server"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  pvc_sites  = k8s_core_v1_persistent_volume_claim.sites.metadata[0].name

  SITE_NAME      = local.site_name
  DEVELOPER_MODE = "0"

  MARIADB_HOST        = module.mysql.name
  DB_PORT             = module.mysql.ports[0].port
  DB_ROOT_USER        = "root"
  MYSQL_ROOT_PASSWORD = "frappe"

  */
/* if using postgres
  POSTGRES_HOST      = module.postgres.name
  DB_PORT            = module.postgres.ports[0].port
  DB_ROOT_USER       = "frappe"
  POSTGRES_PASSWORD  = "frappe"
  */ /*


  REDIS_CACHE    = "${module.redis-cache.name}:${module.redis-cache.ports[0].port}"
  REDIS_QUEUE    = "${module.redis-queue.name}:${module.redis-queue.ports[0].port}"
  REDIS_SOCKETIO = "${module.redis-socketio.name}:${module.redis-socketio.ports[0].port}"
}

module "worker-default" {
  source    = "../../modules/frappe/worker"
  name      = "worker-default"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  pvc_sites = k8s_core_v1_persistent_volume_claim.sites.metadata[0].name
  args = [
  "worker"]
  env         = local.env
  WORKER_TYPE = "default"
}

module "worker-short" {
  source    = "../../modules/frappe/worker"
  name      = "worker-short"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  pvc_sites   = k8s_core_v1_persistent_volume_claim.sites.metadata[0].name
  args        = ["worker"]
  env         = local.env
  WORKER_TYPE = "short"
}

module "worker-long" {
  source    = "../../modules/frappe/worker"
  name      = "worker-long"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  pvc_sites   = k8s_core_v1_persistent_volume_claim.sites.metadata[0].name
  args        = ["worker"]
  env         = local.env
  WORKER_TYPE = "long"
}

module "scheduler" {
  source    = "../../modules/frappe/worker"
  name      = "scheduler"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  pvc_sites = k8s_core_v1_persistent_volume_claim.sites.metadata[0].name
  args      = ["schedule"]
  env       = local.env
}

module "socketio" {
  source    = "../../modules/frappe/socketio"
  name      = "socketio"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  pvc_sites = k8s_core_v1_persistent_volume_claim.sites.metadata[0].name
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "frappe" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "frappe-example.*"
      "nginx.ingress.kubernetes.io/upstream-vhost" = module.server.SITE_NAME
    }
    name      = module.server.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${module.server.name}-${var.namespace}"
      http {
        paths {
          backend {
            service_name = module.server.name
            service_port = module.server.ports[0].port
          }
          path = "/"
        }
        paths {
          backend {
            service_name = module.socketio.name
            service_port = module.socketio.ports[0].port
          }
          path = "/socket.io"
        }
      }
    }
  }
}

*/
/*
For development
*/





