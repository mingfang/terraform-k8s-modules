resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "mysql" {
  source    = "../../modules/mysql"
  name      = "mysql"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 1

  storage       = "1Gi"
  storage_class = "cephfs"

  MYSQL_USER          = "querybook"
  MYSQL_PASSWORD      = "querybook"
  MYSQL_DATABASE      = "querybook"
  MYSQL_ROOT_PASSWORD = "querybook"
}

module "redis" {
  source    = "../../modules/redis"
  name      = "redis"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}

module "elasticsearch" {
  source    = "../../modules/elasticsearch"
  name      = "elasticsearch"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 1

  storage       = "1Gi"
  storage_class = "cephfs"
}

module "querybook-scheduler" {
  source    = "../../modules/querybook/querybook-scheduler"
  name      = "scheduler"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  FLASK_SECRET_KEY   = "secret"
  DATABASE_CONN      = "mysql+pymysql://querybook:querybook@${module.mysql.name}:${module.mysql.ports[0].port}/querybook"
  REDIS_URL          = "redis://${module.redis.name}:${module.redis.ports[0].port}/0"
  ELASTICSEARCH_HOST = "${module.elasticsearch.name}:${module.elasticsearch.ports[0].port}"
}
module "querybook-worker" {
  source    = "../../modules/querybook/querybook-worker"
  name      = "worker"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  FLASK_SECRET_KEY   = "secret"
  DATABASE_CONN      = "mysql+pymysql://querybook:querybook@${module.mysql.name}:${module.mysql.ports[0].port}/querybook"
  REDIS_URL          = "redis://${module.redis.name}:${module.redis.ports[0].port}/0"
  ELASTICSEARCH_HOST = "${module.elasticsearch.name}:${module.elasticsearch.ports[0].port}"
}
module "querybook-web" {
  source    = "../../modules/querybook/querybook-web"
  name      = "web"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  FLASK_SECRET_KEY   = "secret"
  DATABASE_CONN      = "mysql+pymysql://querybook:querybook@${module.mysql.name}:${module.mysql.ports[0].port}/querybook"
  REDIS_URL          = "redis://${module.redis.name}:${module.redis.ports[0].port}/0"
  ELASTICSEARCH_HOST = "${module.elasticsearch.name}:${module.elasticsearch.ports[0].port}"
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "querybook" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}.*"
    }
    name      = module.querybook-web.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = var.namespace
      http {
        paths {
          backend {
            service_name = module.querybook-web.name
            service_port = module.querybook-web.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}
