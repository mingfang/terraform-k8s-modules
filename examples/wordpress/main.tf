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

module "mysql-storage" {
  source        = "../../modules/kubernetes/storage-nfs"
  name          = "mysql"
  namespace     = k8s_core_v1_namespace.this.metadata[0].name
  replicas      = 1
  mount_options = module.nfs-server.mount_options
  nfs_server    = module.nfs-server.service.spec[0].cluster_ip
  storage       = "1Gi"

  annotations = {
    "nfs-server-uid" = module.nfs-server.deployment.metadata[0].uid
  }
}

module "mysql" {
  source        = "../../modules/mysql"
  name          = "mysql"
  namespace     = k8s_core_v1_namespace.this.metadata[0].name
  storage_class = module.mysql-storage.storage_class_name
  storage       = module.mysql-storage.storage
  replicas      = module.mysql-storage.replicas

  MYSQL_USER                    = "wordpress"
  MYSQL_PASSWORD                = "wordpress"
  MYSQL_DATABASE                = "wordpress"
  MYSQL_ROOT_PASSWORD           = "wordpress"
  MYSQL_ROOT_HOST               = "%"
  default-authentication-plugin = "mysql_native_password"
}

module "wordpress" {
  source    = "../../modules/wordpress"
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 1

  WORDPRESS_DB_HOST     = module.mysql.name
  WORDPRESS_DB_NAME     = "wordpress"
  WORDPRESS_DB_USER     = "wordpress"
  WORDPRESS_DB_PASSWORD = "wordpress"
}

resource "k8s_extensions_v1beta1_ingress" "wordpress" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "wordpress.*"
    }
    name      = module.wordpress.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = module.wordpress.name
      http {
        paths {
          backend {
            service_name = module.wordpress.name
            service_port = 80
          }
          path = "/"
        }
      }
    }
  }
}

