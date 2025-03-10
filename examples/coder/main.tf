resource "k8s_core_v1_namespace" "coder" {
  metadata {
    name = var.namespace
  }
}

resource "k8s_core_v1_persistent_volume_claim" "data" {
  metadata {
    name      = "data"
    namespace = k8s_core_v1_namespace.coder.metadata[0].name
  }

  spec {
    access_modes       = ["ReadWriteMany"]
    storage_class_name = "cephfs-csi"

    resources {
      requests = { "storage" = "1Gi" }
    }
  }
}

module "postgres" {
  source    = "../../modules/postgres"
  name      = "postgres"
  namespace = k8s_core_v1_namespace.coder.metadata[0].name
  image     = "registry.rebelsoft.com/postgres:16"

  args = [
    "-c", "work_mem=512MB",
    "-c", "maintenance_work_mem=512MB",
    "-c", "max_wal_size=1GB",
    "-c", "wal_level=logical",
    "-c", "log_statement=all",
    "-c", "max_worker_processes=128",
    "-c", "shared_preload_libraries=pg_stat_statements,pg_net,pg_cron,pg_search"
  ]

  env_map = {
    POSTGRES_USER     = "postgres"
    POSTGRES_PASSWORD = "postgres"
    POSTGRES_DB       = "postgres"
  }

  pvcs = [
    {
      name       = k8s_core_v1_persistent_volume_claim.data.metadata[0].name
      mount_path = "/data"
    }
  ]
}

module "coder" {
  source    = "../../modules/generic-deployment-service"
  name      = var.name
  namespace = k8s_core_v1_namespace.coder.metadata.0.name
  image     = "ghcr.io/coder/coder:latest"
  replicas  = 1
  ports     = [{ name = "tcp", port = 7080 }]

  env_map = {
    CODER_PG_CONNECTION_URL   = "postgresql://postgres:postgres@${module.postgres.name}/postgres?sslmode=disable"
    CODER_HTTP_ADDRESS        = "0.0.0.0:7080"
    CODER_ACCESS_URL          = "https://${var.namespace}.rebelsoft.com"
    CODER_WILDCARD_ACCESS_URL = "*-${var.namespace}.rebelsoft.com"

    CODER_OIDC_SIGN_IN_TEXT          = "Keycloak"
    CODER_OIDC_ISSUER_URL            = "https://keycloak.rebelsoft.com/auth/realms/rebelsoft"
    CODER_OIDC_CLIENT_ID             = "coder-example"
    CODER_OIDC_CLIENT_SECRET         = "Dji3tzTHc0q1plCg9DMOFepW7rsM44jZ"
    CODER_OIDC_IGNORE_EMAIL_VERIFIED = "true"
    CODER_OIDC_GROUP_AUTO_CREATE     = "true"
    CODER_DISABLE_PASSWORD_AUTH      = "true"
    CODER_OIDC_SCOPES                = "openid,profile,email,offline_access"
    CODER_OIDC_AUTH_URL_PARAMS       = <<-EOF
      {"access_type":"offline"}
      EOF
  }

  cluster_role_refs = [
    {
      api_group = "rbac.authorization.k8s.io"
      kind      = "ClusterRole"
      name      = "cluster-admin"
    }
  ]
}

resource "k8s_networking_k8s_io_v1_ingress" "coder" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}.*"
      "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
    }
    name      = var.namespace
    namespace = k8s_core_v1_namespace.coder.metadata.0.name
  }
  spec {
    rules {
      host = var.namespace
      http {
        paths {
          backend {
            service {
              name = module.coder.name
              port {
                number = module.coder.ports.0.port
              }
            }
          }
          path      = "/"
          path_type = "ImplementationSpecific"
        }
      }
    }
  }
}

resource "k8s_networking_k8s_io_v1_ingress" "coder-wildcard" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "~^.*-${var.namespace}.rebelsoft.com"
      "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
    }
    name      = "${var.namespace}-wildcard"
    namespace = k8s_core_v1_namespace.coder.metadata.0.name
  }
  spec {
    rules {
      host = "${var.namespace}-wildcard"
      http {
        paths {
          backend {
            service {
              name = module.coder.name
              port {
                number = module.coder.ports.0.port
              }
            }
          }
          path      = "/"
          path_type = "ImplementationSpecific"
        }
      }
    }
  }
}
