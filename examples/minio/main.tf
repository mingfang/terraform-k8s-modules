resource "k8s_core_v1_namespace" "this" {
  metadata {
    labels = {
      "istio-injection" = "disabled"
    }

    name = var.namespace
  }
}

module "nfs-server" {
  source    = "../../modules/nfs-server-empty-dir"
  name      = "nfs-server"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}

module "minio-storage" {
  source        = "../../modules/kubernetes/storage-nfs"
  name          = "${var.name}"
  namespace     = k8s_core_v1_namespace.this.metadata[0].name
  replicas      = 4
  mount_options = module.nfs-server.mount_options
  nfs_server    = module.nfs-server.service.spec[0].cluster_ip
  storage       = "2Gi"

  annotations = {
    "nfs-server-uid" = module.nfs-server.deployment.metadata[0].uid
  }
}

module "minio" {
  source    = "../../modules/minio"
  name      = "${var.name}"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  replicas           = module.minio-storage.replicas
  storage            = module.minio-storage.storage
  storage_class_name = module.minio-storage.storage_class_name
  minio_access_key   = var.minio_access_key
  minio_secret_key   = var.minio_secret_key
}

module "ingress" {
  source           = "../../modules/kubernetes/ingress-nginx"
  name             = "${var.name}-ingress"
  namespace        = k8s_core_v1_namespace.this.metadata[0].name
  ingress_class    = k8s_core_v1_namespace.this.metadata[0].name
  load_balancer_ip = "192.168.2.242"
  service_type     = "LoadBalancer"
}

resource "k8s_extensions_v1beta1_ingress" "this" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"                 = "nginx"
      "nginx.ingress.kubernetes.io/server-alias"    = "${var.name}.*",
      "certmanager.k8s.io/cluster-issuer"           = "letsencrypt-prod"
      "nginx.ingress.kubernetes.io/auth-url"        = "https://auth.rebelsoft.com/oauth2/auth"
      "nginx.ingress.kubernetes.io/auth-signin"     = "https://auth.rebelsoft.com/oauth2/start?rd=/redirect/$http_host$escaped_request_uri"
      "nginx.ingress.kubernetes.io/proxy-body-size" = "10240m",
    }
    name      = var.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "minio.rebelsoft.com"
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
        "minio.rebelsoft.com"
      ]
      secret_name = "${var.name}-tls"
    }
  }
}
