resource "k8s_core_v1_namespace" "this" {
  metadata {
    labels = {
      "istio-injection" = "disabled"
    }

    name = "corteza-example"
  }
}

module "nfs-provisioner" {
  source        = "../../modules/nfs-provisioner-empty-dir"
  name          = "corteza-nfs"
  namespace     = k8s_core_v1_namespace.this.metadata[0].name
  medium        = "Memory"
  storage_class = k8s_core_v1_namespace.this.metadata[0].name
}

module "database" {
  source = "../../modules/mysql"
  name = "corteza-db"
  namespace     = k8s_core_v1_namespace.this.metadata[0].name
  image = "percona:8.0"

  MYSQL_DATABASE=      "corteza"
  MYSQL_USER=          "corteza"
  MYSQL_PASSWORD=      "change-me"
  MYSQL_ROOT_PASSWORD= "change-me-too"

  storage       = "1Gi"
  storage_class = module.nfs-provisioner.storage_class
}

module "system" {
  source = "../../modules/corteza/system"
  name = "corteza-system"
  namespace     = k8s_core_v1_namespace.this.metadata[0].name

  DB_DSN = "corteza:change-me@tcp(${module.database.name}:3306)/corteza?collation=utf8mb4_general_ci"
  AUTH_JWT_SECRET="secret1234567890"
}

module "compose" {
  source = "../../modules/corteza/compose"
  name = "corteza-compose"
  namespace     = k8s_core_v1_namespace.this.metadata[0].name

  DB_DSN = "corteza:change-me@tcp(${module.database.name}:3306)/corteza?collation=utf8mb4_general_ci"
  AUTH_JWT_SECRET="secret1234567890"
}

module "messaging" {
  source = "../../modules/corteza/messaging"
  name = "corteza-messaging"
  namespace     = k8s_core_v1_namespace.this.metadata[0].name

  DB_DSN = "corteza:change-me@tcp(${module.database.name}:3306)/corteza?collation=utf8mb4_general_ci"
  AUTH_JWT_SECRET="secret1234567890"
}

module "webapp" {
  source = "../../modules/corteza/webapp"
  name = "corteza-webapp"
  namespace     = k8s_core_v1_namespace.this.metadata[0].name

  DB_DSN = "corteza:change-me@tcp(${module.database.name}:3306)/corteza?collation=utf8mb4_general_ci"
  AUTH_JWT_SECRET="secret1234567890"
  VIRTUAL_HOST = "192.168.2.244.nip.io"
}

resource "k8s_extensions_v1beta1_ingress" "system" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "corteza-example"
      "nginx.ingress.kubernetes.io/server-alias" = "system.api.*",
    }
    name      = module.system.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "system"
      http {
        paths {
          backend {
            service_name = module.system.name
            service_port = "80"
          }
          path = "/"
        }
      }
    }
  }
}

resource "k8s_extensions_v1beta1_ingress" "messaging" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "corteza-example"
      "nginx.ingress.kubernetes.io/server-alias" = "messaging.api.*",
    }
    name      = module.messaging.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "messaging"
      http {
        paths {
          backend {
            service_name = module.messaging.name
            service_port = "80"
          }
          path = "/"
        }
      }
    }
  }
}

resource "k8s_extensions_v1beta1_ingress" "compose" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "corteza-example"
      "nginx.ingress.kubernetes.io/server-alias" = "compose.api.*",
    }
    name      = module.compose.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "compose"
      http {
        paths {
          backend {
            service_name = module.compose.name
            service_port = "80"
          }
          path = "/"
        }
      }
    }
  }
}

resource "k8s_extensions_v1beta1_ingress" "webapp" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "corteza-example"
      "nginx.ingress.kubernetes.io/server-alias" = "corteza.*",
    }
    name      = module.webapp.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "corteza"
      http {
        paths {
          backend {
            service_name = module.webapp.name
            service_port = "80"
          }
          path = "/"
        }
      }
    }
  }
}

module "ingress" {
  source           = "../../modules/kubernetes/ingress-nginx"
  name             = "corteza-ingress"
  namespace        = k8s_core_v1_namespace.this.metadata[0].name
  ingress_class    = "corteza-example"
  load_balancer_ip = "192.168.2.244"
  service_type     = "LoadBalancer"
}

