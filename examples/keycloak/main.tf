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

module "postgres-storage" {
  source        = "../../modules/kubernetes/storage-nfs"
  name          = "postgres"
  namespace     = k8s_core_v1_namespace.this.metadata[0].name
  replicas      = 1
  mount_options = module.nfs-server.mount_options
  nfs_server    = module.nfs-server.service.spec[0].cluster_ip
  storage       = "1Gi"

  annotations = {
    "nfs-server-uid" = module.nfs-server.deployment.metadata[0].uid
  }
}

module "postgres" {
  source        = "../../modules/postgres"
  name          = "postgres"
  namespace     = k8s_core_v1_namespace.this.metadata[0].name
  storage_class = module.postgres-storage.storage_class_name
  storage       = module.postgres-storage.storage
  replicas      = module.postgres-storage.replicas
  image         = "postgres:9.6.16"

  POSTGRES_USER     = "keycloak"
  POSTGRES_PASSWORD = "keycloak"
  POSTGRES_DB       = "keycloak"
}

module "keycloak" {
  source    = "../../modules/keycloak"
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  KEYCLOAK_USER     = "keycloak"
  KEYCLOAK_PASSWORD = "keycloak"
  DB_VENDOR         = "postgres"
  DB_ADDR           = "${module.postgres.name}:5432"
  DB_USER           = "keycloak"
  DB_PASSWORD       = "keycloak"
  DB_DATABASE       = "keycloak"
  DB_SCHEMA         = "public"
}

resource "k8s_extensions_v1beta1_ingress" "keycloak" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.name}.*"
      "certmanager.k8s.io/cluster-issuer"        = "letsencrypt-prod"
    }
    name      = module.keycloak.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${var.name}.rebelsoft.com"
      http {
        paths {
          backend {
            service_name = module.keycloak.name
            service_port = 8080
          }
          path = "/"
        }
      }
    }

    tls {
      hosts = [
        "${var.name}.rebelsoft.com"
      ]
      secret_name = "${var.name}-tls"
    }
  }
}

