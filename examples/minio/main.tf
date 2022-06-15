resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "image-pull-secret" {
  source    = "../image-pull-secret"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}

module "minio" {
  source    = "../../modules/minio"
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  replicas           = 4
  storage            = "1Gi"
  storage_class_name = "cephfs"

  minio_access_key = var.minio_access_key
  minio_secret_key = var.minio_secret_key

  create_buckets = ["test"]

  overrides = {
    image_pull_secrets = [
      {
        name = "image-pull-secret"
      }
    ]
  }
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "this" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"                 = "nginx"
      "nginx.ingress.kubernetes.io/server-alias"    = "${var.namespace}.*"
      "nginx.ingress.kubernetes.io/proxy-body-size" = "10240m"
    }
    name      = var.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = var.namespace
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

# gateway

module "policies" {
  source    = "../../modules/kubernetes/config-map"
  name      = "policies"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  from-dir = "${path.module}/policies"
}

module "minio-s3" {
  source    = "../../modules/minio"
  name      = "minio-s3"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 1

  env_map = {
    AWS_ACCESS_KEY_ID     = var.AWS_ACCESS_KEY_ID
    AWS_SECRET_ACCESS_KEY = var.AWS_SECRET_ACCESS_KEY
    MINIO_CACHE           = "on"
    MINIO_CACHE_DRIVES    = "/var/cache"
  }
  args               = ["gateway", "s3", "--console-address", ":9001"]
  minio_access_key   = var.minio_access_key
  minio_secret_key   = var.minio_secret_key
  policies_configmap = module.policies.config_map
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "s3" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"                 = "nginx"
      "nginx.ingress.kubernetes.io/server-alias"    = "s3-${var.namespace}.*"
      "nginx.ingress.kubernetes.io/proxy-body-size" = "10240m"
    }
    name      = "minio-s3"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "s3-${var.namespace}"
      http {
        paths {
          backend {
            service_name = module.minio-s3.name
            service_port = module.minio-s3.ports[1].port
          }
          path = "/"
        }
      }
    }
  }
}
