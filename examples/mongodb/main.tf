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

  ME_CONFIG_MONGODB_URL = "mongodb://mongo:mongo@${module.mongodb.name}:${module.mongodb.ports[0].port}"
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "mongo-express" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}.*"
    }
    name      = module.mongo-express.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = module.mongo-express.name
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

/* RESTHeart */

module "restheart" {
  source    = "../../modules/restheart"
  name      = "restheart"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 1

  MONGO_URI = "mongodb://mongo:mongo@${module.mongodb.name}:${module.mongodb.ports[0].port}"
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "restheart" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "restheart-${var.namespace}.*"
    }
    name      = module.restheart.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = module.restheart.name
      http {
        paths {
          backend {
            service_name = module.restheart.name
            service_port = module.restheart.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}

