resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "postgres" {
  source        = "../../modules/postgres"
  name          = "postgres"
  namespace     = k8s_core_v1_namespace.this.metadata[0].name
  storage_class = "cephfs"
  storage       = "1Gi"

  POSTGRES_USER     = "jira"
  POSTGRES_PASSWORD = "jira"
  POSTGRES_DB       = "jira"
}

resource "k8s_core_v1_persistent_volume_claim" "shared" {
  metadata {
    name      = "shared"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }

  spec {
    access_modes = ["ReadWriteMany"]
    resources { requests = { "storage" = "1Gi" } }
    storage_class_name = "cephfs"
  }
}

module "jira" {
  source    = "../../modules/jira"
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = var.replicas

  pvc_shared    = k8s_core_v1_persistent_volume_claim.shared.metadata[0].name
  storage_class = "cephfs"
  storage       = "1Gi"

  env = [
    { name = "ATL_DB_TYPE", value = "postgres72" },
    { name = "ATL_DB_DRIVER", value = "org.postgresql.Driver" },
    { name = "ATL_JDBC_USER", value = "jira" },
    { name = "ATL_JDBC_PASSWORD", value = "jira" },
    { name = "ATL_DB_SCHEMA_NAME", value = "public" },
    { name = "ATL_JDBC_URL", value = "jdbc:postgresql://postgres:5432/jira" },
    { name = "ATL_TOMCAT_SCHEME", value = "https" },
    { name = "ATL_TOMCAT_SECURE", value = "false" },
  ]
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "this" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}.*"
      "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
    }
    name      = var.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${var.name}-${var.namespace}"
      http {
        paths {
          backend {
            service_name = module.jira.name
            service_port = module.jira.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}
