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

/* Trino */

module "trino-catalog" {
  source    = "../../modules/kubernetes/config-map"
  name      = "trino-catalog"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  from-file = "${path.module}/mongodb.properties"
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
  config_configmap  = module.trino-config.config_map
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
  config_configmap  = module.trino-worker-config.config_map
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "trino" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}.*"
    }
    name      = module.trino.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${var.namespace}"
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

