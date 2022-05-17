resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

/* minio */

module "minio" {
  source    = "../../modules/minio"
  name      = "minio"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  replicas           = 4
  storage            = "1Gi"
  storage_class_name = "cephfs"

  minio_access_key = var.minio_access_key
  minio_secret_key = var.minio_secret_key

  create_buckets = ["lakefs"]
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "minio" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"                 = "nginx"
      "nginx.ingress.kubernetes.io/server-alias"    = "${var.namespace}-minio.*"
      "nginx.ingress.kubernetes.io/proxy-body-size" = "10240m"
    }
    name      = "minio"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${var.namespace}-minio"
      http {
        paths {
          backend {
            service_name = module.minio.name
            service_port = module.minio.ports[1].port
          }
          path = "/"
        }
      }
    }
  }
}

/* lakefs */

module "postgres" {
  source    = "../../modules/postgres"
  name      = "postgres"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 1

  storage_class = "cephfs"
  storage       = "1Gi"

  POSTGRES_USER     = "lakefs"
  POSTGRES_PASSWORD = "lakefs"
  POSTGRES_DB       = "lakefs"
}

module "lakefs" {
  source    = "../../modules/lakefs"
  name      = "lakefs"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 1

  env_map = {
    LAKEFS_BLOCKSTORE_TYPE                             = "s3"
    LAKEFS_BLOCKSTORE_S3_FORCE_PATH_STYLE              = "true"
    LAKEFS_BLOCKSTORE_S3_ENDPOINT                      = "http://${module.minio.name}:${module.minio.ports[0].port}"
    LAKEFS_BLOCKSTORE_S3_CREDENTIALS_ACCESS_KEY_ID     = var.minio_access_key
    LAKEFS_BLOCKSTORE_S3_CREDENTIALS_SECRET_ACCESS_KEY = var.minio_secret_key
    LAKEFS_AUTH_ENCRYPT_SECRET_KEY                     = "secret"
    LAKEFS_DATABASE_CONNECTION_STRING                  = "postgres://lakefs:lakefs@${module.postgres.name}/lakefs?sslmode=disable"
    LAKEFS_STATS_ENABLED                               = "false"
    LAKEFS_LOGGING_LEVEL                               = "debug"
  }
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "lakefs" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"                 = "nginx"
      "nginx.ingress.kubernetes.io/server-alias"    = "${var.namespace}.*"
      "nginx.ingress.kubernetes.io/proxy-body-size" = "10240m"
    }
    name      = "lakefs"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = var.namespace
      http {
        paths {
          backend {
            service_name = module.lakefs.name
            service_port = module.lakefs.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}

/*
Access Key ID:
AKIAJ5JLHONNHBRQAZOQ
Secret Access Key:
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
*/