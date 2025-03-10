resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
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

module "nocodb" {
  source    = "../../modules/nocodb"
  name = "nocodb"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 1

  NC_DB_JSON = <<-EOF
  {
    "client": "pg",
    "connection": {
      "host": "${module.postgres.name}",
      "port": "5432",
      "user": "postgres",
      "password": "postgres",
      "database": "postgres"
    },
    "meta": {
      "tn": "nc_evolutions",
      "dbAlias": "db",
      "api": {
        "type": "rest",
        "prefix": "",
        "graphqlDepthLimit": 10
      },
      "inflection": {
      "tn": "camelize",
      "cn": "camelize"
      }
    },
    "ui": {
    "setup": 0,
      "ssl": {
        "key": "Client Key",
        "cert": "Client Cert",
        "ca": "Server CA"
      },
      "sslUse": "Preferred"
    }
  }
  EOF
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "this" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}.*"
    }
    name        = module.nocodb.name
    namespace   = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = var.namespace
      http {
        paths {
          backend {
            service_name = module.nocodb.name
            service_port = 8080
          }
          path = "/"
        }
      }
    }
  }
}

