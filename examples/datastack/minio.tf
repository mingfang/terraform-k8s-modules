module "minio" {
  source    = "../../modules/minio"
  name      = "minio"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  replicas           = 4
  storage            = "1Gi"
  storage_class_name = "cephfs"

  minio_access_key = var.minio_access_key
  minio_secret_key = var.minio_secret_key

  create_buckets = ["test"]
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
