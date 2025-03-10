resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

resource "k8s_core_v1_persistent_volume_claim" "data" {
  metadata {
    name      = "data"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }

  spec {
    access_modes       = ["ReadWriteMany"]
    storage_class_name = "cephfs"

    resources {
      requests = { "storage" = "1Gi" }
    }
  }
}

module "pgadmin" {
  source    = "../../modules/pgadmin"
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  pvcs = [
    {
      name       = k8s_core_v1_persistent_volume_claim.data.metadata.0.name
      mount_path = "/var/lib/pgadmin"
    }
  ]
  pvc_user = "pgadmin"

  env_map = {
    PGADMIN_DEFAULT_EMAIL                   = "mingfang@mac.com"
    PGADMIN_DEFAULT_PASSWORD                = "SuperSecret"
    PGADMIN_DISABLE_POSTFIX                 = "True"
    PGADMIN_SERVER_MODE                     = "True"
    PGADMIN_CONFIG_MAX_SESSION_IDLE_TIME    = "6000"
    PGADMIN_CONFIG_MASTER_PASSWORD_REQUIRED = "False"

    PGADMIN_CONFIG_AUTHENTICATION_SOURCES = "[\"oauth2\"]"
    PGADMIN_CONFIG_OAUTH2_CONFIG          = <<-EOF
    [${jsonencode({
      OAUTH2_NAME = "Keycloak"
      OAUTH2_DISPLAY_NAME = "Keycloak"
      OAUTH2_CLIENT_ID= "pgadmin-example"
      OAUTH2_CLIENT_SECRET = "YAaapjfSOrKnOwgGXK6mDC6madcyLcfp"
      OAUTH2_TOKEN_URL = "https://keycloak.rebelsoft.com/auth/realms/rebelsoft/protocol/openid-connect/token"
      OAUTH2_AUTHORIZATION_URL = "https://keycloak.rebelsoft.com/auth/realms/rebelsoft/protocol/openid-connect/auth"
      OAUTH2_API_BASE_URL = "https://keycloak.rebelsoft.com/auth/realms/rebelsoft/"
      OAUTH2_USERINFO_ENDPOINT = "https://keycloak.rebelsoft.com/auth/realms/rebelsoft/protocol/openid-connect/userinfo"
      OAUTH2_SERVER_METADATA_URL = "https://keycloak.rebelsoft.com/auth/realms/rebelsoft/.well-known/openid-configuration"
      OAUTH2_SCOPE = "openid email profile"
    })}]
    EOF
  }
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "this" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}.*"
      "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
    }
    name      = var.namespace
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = var.namespace
      http {
        paths {
          backend {
            service_name = module.pgadmin.name
            service_port = module.pgadmin.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}
