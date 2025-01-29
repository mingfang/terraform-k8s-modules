resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "mongodb" {
  source    = "../../modules/generic-statefulset-service"
  name      = "mongodb"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  image     = "mongo"
  ports     = [{ name = "tcp", port = 27017 }]
  storage   = "1Gi"

  env_map = {
    MONGO_INITDB_DATABASE      = "mydb"
    MONGO_INITDB_ROOT_USERNAME = "mongo"
    MONGO_INITDB_ROOT_PASSWORD = "mongo"
  }
}

/* Optional Mongo Express UI */

module "mongo-express" {
  source    = "../../modules/generic-deployment-service"
  name      = "mongo-express"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  image     = "mongo-express"
  ports     = [{ name = "tcp", port = 8081 }]

  env_map = {
    ME_CONFIG_MONGODB_URL = "mongodb://mongo:mongo@${module.mongodb.name}"
  }
}

resource "k8s_networking_k8s_io_v1_ingress" "mongo-express" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "mongo-express-${var.namespace}.*"
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
            service {
              name = module.mongo-express.name
              port {
                number = module.mongo-express.ports[0].port
              }
            }
          }
          path      = "/"
          path_type = "ImplementationSpecific"
        }
      }
    }
  }
}

