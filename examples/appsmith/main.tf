resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "redis" {
  source    = "../../modules/redis"
  name      = "redis"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  replicas = 1
}

module "mongodb" {
  source    = "../../modules/mongodb"
  name      = "mongodb"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  replicas      = 1
  storage       = "1Gi"
  storage_class = "cephfs"

  MONGO_INITDB_DATABASE      = "appsmith"
  MONGO_INITDB_ROOT_USERNAME = "mongodb"
  MONGO_INITDB_ROOT_PASSWORD = "mongodb"
}

module "server" {
  source    = "../../modules/appsmith/server"
  name      = "server"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  APPSMITH_REDIS_URL           = "redis://${module.redis.name}:${module.redis.ports[0].port}"
  APPSMITH_MONGODB_URI         = "mongodb://mongodb:mongodb@${module.mongodb.name}/appsmith?retryWrites=true&authSource=admin"
  APPSMITH_ENCRYPTION_PASSWORD = "appsmith"
  APPSMITH_ENCRYPTION_SALT     = "appsmith"

  // hack to integrate Appsmith with Keycloak
  env = [
    {
      name  = "SPRING_SECURITY_OAUTH2_CLIENT_PROVIDER_GOOGLE_ISSUER-URI"
      value = "https://keycloak.rebelsoft.com/auth/realms/rebelsoft"
    },
    {
      name  = "SPRING_SECURITY_OAUTH2_CLIENT_PROVIDER_GOOGLE_USER-NAME-ATTRIBUTE"
      value = "email"
    },
    {
      name  = "SPRING_SECURITY_OAUTH2_CLIENT_REGISTRATION_GOOGLE_CLIENT-ID"
      value = "appsmith"
    },
    {
      name  = "SPRING_SECURITY_OAUTH2_CLIENT_REGISTRATION_GOOGLE_CLIENT-SECRET"
      value = "10858fa0-11a5-41a3-862e-d100fb6f6387"
    },
    {
      name  = "SPRING_SECURITY_OAUTH2_CLIENT_REGISTRATION_GOOGLE_AUTHORIZATION-GRANT-TYPE"
      value = "authorization_code"
    },
    {
      name  = "SPRING_SECURITY_OAUTH2_CLIENT_REGISTRATION_GOOGLE_REDIRECT-URI"
      value = "{baseUrl}/login/oauth2/code/{registrationId}"
    },
  ]
}

module "editor" {
  source    = "../../modules/appsmith/editor"
  name      = "editor"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  // hack to enable logging in using the server config above
  APPSMITH_OAUTH2_GOOGLE_CLIENT_ID = "hack"
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "this" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "appsmith-example.*"
      // auto login using oauth
      "nginx.ingress.kubernetes.io/server-snippet" = <<-EOF
        location ~ /user/login {
          return 301 /oauth2/authorization/google;
        }
        EOF
    }
    name      = module.editor.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${var.name}.${var.namespace}"
      http {
        paths {
          path = "/api"
          backend {
            service_name = module.server.name
            service_port = module.server.ports[0].port
          }
        }
        paths {
          path = "/oauth2"
          backend {
            service_name = module.server.name
            service_port = module.server.ports[0].port
          }
        }
        paths {
          path = "/login"
          backend {
            service_name = module.server.name
            service_port = module.server.ports[0].port
          }
        }
        paths {
          path = "/"
          backend {
            service_name = module.editor.name
            service_port = module.editor.ports[0].port
          }
        }
      }
    }
  }
}


