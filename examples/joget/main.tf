resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "mysql" {
  source    = "../../modules/mysql"
  name      = "mysql"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 1

  storage       = "1Gi"
  storage_class = "cephfs"

  MYSQL_USER          = "mysql"
  MYSQL_PASSWORD      = "mysql"
  MYSQL_ROOT_PASSWORD = "mysql"
  MYSQL_DATABASE      = "jwdb"
}

module "joget" {
  source    = "../../modules/joget"
  name      = "joget"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 1

  env_map = {
    MYSQL_HOST     = module.mysql.name
    MYSQL_PORT     = module.mysql.ports[0].port
    MYSQL_USER     = "mysql"
    MYSQL_PASSWORD = "mysql"
    MYSQL_DATABASE = "jwdb"
  }
}
resource "k8s_networking_k8s_io_v1beta1_ingress" "joget" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"                 = "nginx"
      "nginx.ingress.kubernetes.io/server-alias"    = "${var.namespace}.*"
      "nginx.ingress.kubernetes.io/ssl-redirect"    = "true"
      "nginx.ingress.kubernetes.io/proxy-body-size" = "10240m"
      "nginx.ingress.kubernetes.io/server-snippet"  = <<-EOF
      underscores_in_headers on;
      EOF
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
            service_name = module.joget.name
            service_port = module.joget.ports[1].port
          }
          path = "/"
        }
      }
    }
  }
}
