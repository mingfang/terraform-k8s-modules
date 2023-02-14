resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "mongodb" {
  source    = "../../modules/generic-deployment-service"
  name      = "mongodb"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  image     = "mongo:4.4"
  ports     = [{ name = "tcp", port = 27017 }]
  env_map   = {
    MONGO_INITDB_DATABASE      = "openblocks"
    MONGO_INITDB_ROOT_USERNAME = "openblocks"
    MONGO_INITDB_ROOT_PASSWORD = "secret123"
  }
}

module "redis" {
  source    = "../../modules/generic-deployment-service"
  name      = "redis"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  image     = "redis:7-alpine"
  ports     = [{ name = "tcp", port = 6379 }]
}

module "node-service" {
  source    = "../../modules/openblocks/node-service"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  env_map   = {
    PUID                       = "9001"
    PGID                       = "9001"
    OPENBLOCKS_API_SERVICE_URL = "http://api-service:8080"
  }
}

module "api-service" {
  source    = "../../modules/openblocks/api-service"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  env_map   = {
    PUID                 = "9001"
    PGID                 = "9001"
    MONGODB_URI          = "mongodb://openblocks:secret123@mongodb/openblocks?authSource=admin"
    REDIS_URL            = "redis://redis:6379"
    JS_EXECUTOR_URI      = "http://node-service:6060"
    ENABLE_USER_SIGN_UP  = "true"
    ENCRYPTION_PASSWORD  = "openblocks.dev"
    ENCRYPTION_SALT      = "openblocks.dev"
    CORS_ALLOWED_DOMAINS = "*"
  }
}

module "frontend" {
  source    = "../../modules/openblocks/frontend"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  env_map   = {
    PUID                        = "9001"
    PGID                        = "9001"
    OPENBLOCKS_API_SERVICE_URL  = "http://api-service:8080"
    OPENBLOCKS_NODE_SERVICE_URL = "http://node-service:6060"
  }
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "this" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}.*"
      "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
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
            service_name = module.frontend.name
            service_port = module.frontend.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}
