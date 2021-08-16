resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "splitgraph" {
  source        = "../../modules/splitgraph"
  name          = var.name
  namespace     = k8s_core_v1_namespace.this.metadata[0].name
  storage_class = "cephfs"
  storage       = "1Gi"
  replicas      = 1

  POSTGRES_USER     = "splitgraph"
  POSTGRES_PASSWORD = "splitgraph"
  POSTGRES_DB       = "splitgraph"

  SG_S3_HOST   = "${module.minio.name}.${var.namespace}"
  SG_S3_PORT   = module.minio.ports[0].port
  SG_S3_KEY    = var.minio_access_key
  SG_S3_PWD    = var.minio_secret_key
  SG_S3_BUCKET = "splitgraph"
}

module "minio" {
  source    = "../../modules/minio"
  name      = "minio"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  replicas           = 4
  storage            = "1Gi"
  storage_class_name = "cephfs"

  minio_access_key = var.minio_access_key
  minio_secret_key = var.minio_secret_key

  create_buckets = [
    "splitgraph"
  ]
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "minio" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"                 = "nginx"
      "nginx.ingress.kubernetes.io/proxy-body-size" = "10240m"
      "nginx.ingress.kubernetes.io/server-alias"    = "${var.namespace}-minio.*"
    }
    name      = module.minio.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${var.namespace}-minio"
      http {
        paths {
          backend {
            service_name = module.minio.name
            service_port = module.minio.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "minio-console" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"                 = "nginx"
      "nginx.ingress.kubernetes.io/proxy-body-size" = "10240m"
      "nginx.ingress.kubernetes.io/server-alias"    = "${var.namespace}-minio-console.*"
    }
    name      = "${module.minio.name}-console"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${var.namespace}-minio-console"
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
