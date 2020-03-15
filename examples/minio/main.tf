resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "nfs-server" {
  source    = "../../modules/nfs-server-empty-dir"
  name      = "nfs-server"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}

module "minio-storage" {
  source    = "../../modules/kubernetes/storage-nfs"
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  replicas = var.replicas
  storage  = "2Gi"

  mount_options = module.nfs-server.mount_options
  nfs_server    = module.nfs-server.service.spec[0].cluster_ip

  annotations = {
    "nfs-server-uid" = module.nfs-server.deployment.metadata[0].uid
  }
}

module "minio" {
  source    = "../../modules/minio"
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  replicas           = module.minio-storage.replicas
  storage            = module.minio-storage.storage
  storage_class_name = module.minio-storage.storage_class_name

  minio_access_key = var.minio_access_key
  minio_secret_key = var.minio_secret_key
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "this" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"                 = "nginx"
      "nginx.ingress.kubernetes.io/proxy-body-size" = "10240m"
      "cert-manager.io/cluster-issuer"              = "letsencrypt-prod"
    }
    name      = var.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${var.namespace}.rebelsoft.com"
      http {
        paths {
          backend {
            service_name = module.minio.service.metadata[0].name
            service_port = module.minio.service.spec[0].ports[0].port
          }
          path = "/"
        }
      }
    }

    tls {
      hosts = [
        "${var.namespace}.rebelsoft.com"
      ]
      secret_name = "${var.namespace}.rebelsoft.com-tls"
    }
  }
}
