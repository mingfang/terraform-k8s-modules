resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

resource "random_password" "keyfile" {
  length  = 256
  special = false
}

module "secret" {
  source    = "../../modules/kubernetes/secret"
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  from-map = {
    "keyfile" = base64encode(random_password.keyfile.result)
  }
}

/* MongoDB Replica Set */

module "mongodb" {
  source    = "../../modules/mongodb"
  name      = "mongodb"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 2

  storage_class = "cephfs"
  storage       = "1Gi"

  MONGO_INITDB_DATABASE      = "mydb"
  MONGO_INITDB_ROOT_USERNAME = "mongo"
  MONGO_INITDB_ROOT_PASSWORD = "mongo"
  keyfile_secret             = module.secret.name
}

/* Optional Mongo Express UI */

module "mongo-express" {
  source    = "../../modules/mongo-express"
  name      = "mongo-express"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 1

  ME_CONFIG_MONGODB_URL = "mongodb://mongo:mongo@${module.mongodb.seed_list}"
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "mongo-express" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "mongo-express-${var.namespace}.*"

      "nginx.ingress.kubernetes.io/auth-url"              = "https://oauth.rebelsoft.com/oauth2/auth"
      "nginx.ingress.kubernetes.io/auth-signin"           = "https://oauth.rebelsoft.com/oauth2/start?rd=https://$host$escaped_request_uri"
      "nginx.ingress.kubernetes.io/auth-response-headers" = "X-Auth-Request-User, X-Auth-Request-Email"
    }
    name      = module.mongo-express.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "mongo-express-${var.namespace}"
      http {
        paths {
          backend {
            service_name = module.mongo-express.name
            service_port = module.mongo-express.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}

/* postgres */

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

/* RESTHeart */



/* Eve */




/* Meilisearch */

module "meilisearch" {
  source    = "../../modules/meilisearch"
  name      = "meilisearch"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 1

  storage_class = "cephfs"
  storage       = "1Gi"
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "meilisearch" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "meilisearch-${var.namespace}.*"

      "nginx.ingress.kubernetes.io/auth-url"              = "https://oauth.rebelsoft.com/oauth2/auth"
      "nginx.ingress.kubernetes.io/auth-signin"           = "https://oauth.rebelsoft.com/oauth2/start?rd=https://$host$escaped_request_uri"
      "nginx.ingress.kubernetes.io/auth-response-headers" = "X-Auth-Request-User, X-Auth-Request-Email"
    }
    name      = module.meilisearch.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "meilisearch-${var.namespace}"
      http {
        paths {
          backend {
            service_name = module.meilisearch.name
            service_port = module.meilisearch.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}

/* Trino */

module "trino-catalog" {
  source    = "../../modules/kubernetes/config-map"
  name      = "trino-catalog"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  from-dir = "${path.module}/catalog"
}

module "trino-config" {
  source    = "../../modules/kubernetes/config-map"
  name      = "trino-config"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  from-map = {
    "config.properties" = <<-EOF
      coordinator=true
      node-scheduler.include-coordinator=false
      http-server.http.port=8080
      discovery.uri=http://localhost:8080
    EOF
  }
}

module "trino" {
  source    = "../../modules/trino"
  name      = "trino"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 1

  catalog_configmap = module.trino-catalog.config_map
  config_configmap = module.trino-config.config_map
}

module "trino-worker-config" {
  source    = "../../modules/kubernetes/config-map"
  name      = "trino-worker-config"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  from-map = {
    "config.properties" = <<-EOF
      coordinator=false
      node-scheduler.include-coordinator=true
      http-server.http.port=8080
      discovery.uri=http://trino-0.trino:8080
    EOF
  }
}

module "trino-worker" {
  source    = "../../modules/trino"
  name      = "trino-worker"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 2

  catalog_configmap = module.trino-catalog.config_map
  config_configmap = module.trino-worker-config.config_map
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "trino" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "trino-${var.namespace}.*"

      "nginx.ingress.kubernetes.io/auth-url"              = "https://oauth.rebelsoft.com/oauth2/auth"
      "nginx.ingress.kubernetes.io/auth-signin"           = "https://oauth.rebelsoft.com/oauth2/start?rd=https://$host$escaped_request_uri"
      "nginx.ingress.kubernetes.io/auth-response-headers" = "X-Auth-Request-User, X-Auth-Request-Email"
    }
    name      = module.trino.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "trino-${var.namespace}"
      http {
        paths {
          backend {
            service_name = module.trino.name
            service_port = module.trino.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}

