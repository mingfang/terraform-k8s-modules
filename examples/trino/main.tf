resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

/* MongoDB Replica Set */

module "ferretdb" {
  source    = "../../modules/ferretdb"
  name      = "ferretdb"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  env_map = {
    FERRETDB_POSTGRESQL_URL = "postgres://postgres:postgres@${module.postgres.name}:${module.postgres.ports.0.port}/postgres?sslmode=disable"
  }
}

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
      web-ui.shared-secret=trino
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

  resources =  {
    requests = {
      cpu    = "500m"
      memory = "1Gi"
    }
    limits = {
      memory = "4Gi"
    }
  }
}

module "trino-worker-config" {
  source    = "../../modules/kubernetes/config-map"
  name      = "trino-worker-config"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  from-map = {
    "config.properties" = <<-EOF
      coordinator=false
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

  resources =  {
    requests = {
      cpu    = "500m"
      memory = "1Gi"
    }
    limits = {
      memory = "4Gi"
    }
  }

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
      host = var.namespace
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

/*
module "sqlpad" {
  source = "../../modules/sqlpad"
  name = "sqlpad"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  env_map = {
    SQLPAD_ADMIN= "admin@sqlpad.com"
    SQLPAD_ADMIN_PASSWORD= "admin"
    SQLPAD_APP_LOG_LEVEL= "debug"
    SQLPAD_WEB_LOG_LEVEL= "warn"
    SQLPAD_CONNECTIONS__trino__name= "trino"
    SQLPAD_CONNECTIONS__trino__driver= "trino"
    SQLPAD_CONNECTIONS__trino__host= "trino"
    SQLPAD_CONNECTIONS__trino__username= "trino"
    SQLPAD_CONNECTIONS__trino__catalog= "cockroachdb"
  }
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "sqlpad" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "sqlpad-${var.namespace}.*"
    }
    name      = module.sqlpad.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "sqlpad-${var.namespace}"
      http {
        paths {
          backend {
            service_name = module.sqlpad.name
            service_port = module.sqlpad.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}
*/
