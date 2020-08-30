resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "zookeeper" {
  source    = "../../modules/zookeeper"
  name      = "zookeeper"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  replicas      = 1
  storage       = "1Gi"
  storage_class = var.storage_class_name
}

module "kafka" {
  source    = "../../modules/confluentinc/kafka"
  name      = "kafka"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  storage_class = var.storage_class_name
  storage       = "1Gi"
  replicas      = 3

  KAFKA_ZOOKEEPER_CONNECT = "${module.zookeeper.name}:${module.zookeeper.ports[0].port}"
}

module "schema-registry" {
  source    = "../../modules/confluentinc/schema-registry"
  name      = "schema-registry"
  namespace = var.namespace

  SCHEMA_REGISTRY_KAFKASTORE_BOOTSTRAP_SERVERS = "${module.kafka.name}:${module.kafka.ports[0].port}"
}

module "control-center" {
  source    = "../../modules/confluentinc/control-center"
  name      = "control-center"
  namespace = var.namespace

  CONTROL_CENTER_ZOOKEEPER_CONNECT   = "${module.zookeeper.name}:${module.zookeeper.ports[0].port}"
  CONTROL_CENTER_BOOTSTRAP_SERVERS   = "${module.kafka.name}:${module.kafka.ports[0].port}"
  CONTROL_CENTER_SCHEMA_REGISTRY_URL = "http://${module.schema-registry.name}:${module.schema-registry.ports[0].port}"
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "control-center" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "kafka-${var.namespace}.*"
    }
    name      = module.control-center.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "kafka-${var.name}-${var.namespace}"
      http {
        paths {
          backend {
            service_name = module.control-center.name
            service_port = module.control-center.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}

module "redis" {
  source    = "../../modules/redis"
  name      = "redis"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}

module "couchdb" {
  source    = "../../modules/couchdb"
  name      = "couchdb"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  replicas      = 1
  storage       = "1Gi"
  storage_class = var.storage_class_name

  NODENAME        = "couchdb0"
  db_secret_name  = module.db-secret.name
  db_username_key = "db_username"
  db_password_key = "db_password"
}

module "whisk-config" {
  source               = "../../modules/openwhisk/whisk-config"
  name                 = "whisk-config"
  namespace            = k8s_core_v1_namespace.this.metadata[0].name
  whisk_api_host_proto = "http"
  whisk_api_host_name  = "nginx"
  whisk_api_host_port  = "80"
}

module "whisk-secret" {
  source    = "../../modules/openwhisk/whisk-secret"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}

module "db-config" {
  source    = "../../modules/openwhisk/db-config"
  name      = "db-config"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  db_host   = module.couchdb.name
  db_port   = module.couchdb.ports[0].port
}

module "db-secret" {
  source    = "../../modules/openwhisk/db-secret"
  name      = "db-secret"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}

module "init" {
  source    = "../../modules/openwhisk/init"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  whisk_config_name         = module.whisk-config.name
  whisk_secret_name         = module.whisk-secret.name
  db_config_name            = module.db-config.name
  db_secret_name            = module.db-secret.name
  WHISK_API_GATEWAY_HOST_V2 = "http://${module.apigateway.name}:${module.apigateway.ports[0].port}/v2"
}

module "admin" {
  source    = "../../modules/openwhisk/admin"
  name      = "admin"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  whisk_config_name = module.whisk-config.name
  whisk_secret_name = module.whisk-secret.name
  db_config_name    = module.db-config.name
  db_secret_name    = module.db-secret.name
}

module "apigateway" {
  source    = "../../modules/openwhisk/apigateway"
  name      = "apigateway"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  whisk_config_name = module.whisk-config.name
  REDIS_HOST        = module.redis.name
  REDIS_PORT        = module.redis.ports[0].port
}

module "controller" {
  source    = "../../modules/openwhisk/controller"
  name      = "controller"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  whisk_config_name = module.whisk-config.name
  db_config_name    = module.db-config.name
  db_secret_name    = module.db-secret.name
  KAFKA_HOSTS       = "${module.kafka.name}:${module.kafka.ports[0].port}"
}

module "invoker" {
  source    = "../../modules/openwhisk/invoker"
  name      = "invoker"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  whisk_config_name = module.whisk-config.name
  db_config_name    = module.db-config.name
  db_secret_name    = module.db-secret.name
  KAFKA_HOSTS       = "${module.kafka.name}:${module.kafka.ports[0].port}"
  ZOOKEEPER_HOSTS   = "${module.zookeeper.name}:${module.zookeeper.ports[0].port}"
}

module "nginx" {
  source    = "../../modules/openwhisk/nginx"
  name      = "nginx"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  controller = module.controller.name
  apigateway = module.apigateway.name
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "nginx" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "nginx-${var.namespace}.*"
    }
    name      = module.nginx.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "nginx-${var.name}-${var.namespace}"
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



