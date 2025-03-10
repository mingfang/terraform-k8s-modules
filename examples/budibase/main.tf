resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "secret" {
  source    = "../../modules/kubernetes/secret"
  name      = "couchdb"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  from-map = {
    "db_username" = base64encode("foo")
    "db_password" = base64encode("bar")
  }
}

module "couchdb" {
  source    = "../../modules/couchdb"
  name      = "couchdb"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  replicas      = 1
  storage       = "1Gi"
  storage_class = var.storage_class_name

  db_secret_name  = module.secret.name
  db_username_key = "db_username"
  db_password_key = "db_password"
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
}

module "redis" {
  source    = "../../modules/redis"
  name      = "redis"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  password  = "redis"
}

module "budibase-apps" {
  source    = "../../modules/budibase/budibase-apps"
  name      = "budibase-apps"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 1

  COUCH_DB_URL     = "http://foo:bar@${module.couchdb.name}:${module.couchdb.ports[0].port}"
  WORKER_URL       = "http://budibase-worker:4003"
  MINIO_URL        = "http://${module.minio.name}:${module.minio.ports[0].port}"
  MINIO_ACCESS_KEY = var.minio_access_key
  MINIO_SECRET_KEY = var.minio_secret_key
  INTERNAL_API_KEY = "INTERNAL_API_KEY"
  JWT_SECRET       = "JWT_SECRET"
  REDIS_URL        = "${module.redis.name}:${module.redis.ports[0].port}"
  REDIS_PASSWORD   = "redis"
  LOG_LEVEL        = "info"
}

module "budibase-worker" {
  source    = "../../modules/budibase/budibase-worker"
  name      = "budibase-worker"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  COUCH_DB_USERNAME = "foo"
  COUCH_DB_PASSWORD = "bar"
  COUCH_DB_URL      = "http://foo:bar@${module.couchdb.name}:${module.couchdb.ports[0].port}"
  APPS_URL          = "http://${module.budibase-apps.name}:${module.budibase-apps.ports[0].port}"
  MINIO_URL         = "http://${module.minio.name}:${module.minio.ports[0].port}"
  MINIO_ACCESS_KEY  = var.minio_access_key
  MINIO_SECRET_KEY  = var.minio_secret_key
  INTERNAL_API_KEY  = "INTERNAL_API_KEY"
  JWT_SECRET        = "JWT_SECRET"
  REDIS_URL         = "${module.redis.name}:${module.redis.ports[0].port}"
  REDIS_PASSWORD    = "redis"
  LOG_LEVEL         = "info"
}

module "nginx" {
  source    = "../../modules/nginx"
  name      = "proxy"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  nginx-conf = templatefile("${path.module}/nginx.conf", {
    apps    = module.budibase-apps,
    worker  = module.budibase-worker,
    couchdb = module.couchdb,
    minio   = module.minio,
  })
}

resource "k8s_extensions_v1beta1_ingress" "proxy" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"                 = "nginx"
      "nginx.ingress.kubernetes.io/server-alias"    = "${var.namespace}.*"
      "nginx.ingress.kubernetes.io/proxy-body-size" = "1000m"
      "nginx.ingress.kubernetes.io/server-snippet"  = <<-EOF
      ignore_invalid_headers off;
      EOF
    }
    name      = var.namespace
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = var.namespace
      http {
        paths {
          backend {
            service_name = module.nginx.name
            service_port = module.nginx.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}
