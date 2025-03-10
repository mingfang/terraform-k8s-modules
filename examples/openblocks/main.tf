resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

resource "k8s_core_v1_persistent_volume_claim" "data" {
  metadata {
    name      = "mongodb"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }

  spec {
    access_modes       = ["ReadWriteOnce"]
    resources { requests = { "storage" = "1Gi" } }
    storage_class_name = "cephfs"
  }
}

module "mongodb" {
  source    = "../../modules/generic-deployment-service"
  name      = "mongodb"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  image     = "mongo:6.0.5"
  ports     = [{ name = "tcp", port = 27017 }]
  args      = [
    "--wiredTigerCacheSizeGB", "1.5",
  ]
  env_map = {
    MONGO_INITDB_DATABASE      = "openblocks"
    MONGO_INITDB_ROOT_USERNAME = "openblocks"
    MONGO_INITDB_ROOT_PASSWORD = "secret123"
  }
  pvc = k8s_core_v1_persistent_volume_claim.data.metadata.0.name
  mount_path = "/data/db"
}

module "ferretdb" {
  source    = "../../modules/ferretdb"
  name      = "ferretdb"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  env_map   = {
    FERRETDB_POSTGRESQL_URL = "postgres://postgres:postgres@postgres.neon-example:5432/postgres?sslmode=disable"
  }
}

module "redis" {
  source    = "../../modules/generic-deployment-service"
  name      = "redis"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  image     = "redis:7-alpine"
  ports     = [{ name = "tcp", port = 6379 }]
}

module "node-service" {
  source    = "../../modules/openblocks/node-service"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 1
  env_map   = {
    PUID                       = "9001"
    PGID                       = "9001"
    OPENBLOCKS_API_SERVICE_URL = "http://api-service:8080"
  }
  image = "registry.rebelsoft.com/openblocks-ce-node-service:latest"
}

module "api-service" {
  source    = "../../modules/openblocks/api-service"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 1
  env_map   = {
    MONGODB_URI_          = "mongodb://openblocks:secret123@${module.mongodb.name}:${module.mongodb.ports.0.port}/openblocks?authSource=admin"
    REDIS_URL             = "redis://${module.redis.name}:${module.redis.ports.0.port}"
    JS_EXECUTOR_URI       = "http://${module.node-service.name}:${module.node-service.ports.0.port}"
    ENABLE_USER_SIGN_UP   = "true"
    ENCRYPTION_PASSWORD   = "openblocks.dev"
    ENCRYPTION_SALT       = "openblocks.dev"
    CORS_ALLOWED_DOMAINS  = "*"
    CUSTOM_APP_PROPERTIES = ""

    KEYCLOAK_CLIENT_ID        = "openblocks-example"
    KEYCLOAK_CLIENT_SECRET    = "7197b5ee-23bb-4c21-ab28-2f750936cffa"
    KEYCLOAK_ISSUER_URI       = "https://keycloak.rebelsoft.com/auth/realms/openblocks-example/protocol/openid-connect/auth"
    KEYCLOAK_ACCESS_TOKEN_URI = "https://keycloak.rebelsoft.com/auth/realms/openblocks-example/protocol/openid-connect/token"
    KEYCLOAK_USER_INFO_URI    = "https://keycloak.rebelsoft.com/auth/realms/openblocks-example/protocol/openid-connect/userinfo"
    KEYCLOAK_REDIRECT_URI     = "https://openblocks-example.rebelsoft.com/api/auth/callback/tp/login/keycloak"
  }
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

  image = "registry.rebelsoft.com/openblocks-ce-api-service:latest"
}

module "frontend" {
  source    = "../../modules/openblocks/frontend"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 1
  env_map   = {
    PUID                        = "9001"
    PGID                        = "9001"
    OPENBLOCKS_API_SERVICE_URL  = "http://${module.api-service.name}:${module.api-service.ports.0.port}"
    OPENBLOCKS_NODE_SERVICE_URL = "http://${module.node-service.name}:${module.node-service.ports.0.port}"
  }
  image = "registry.rebelsoft.com/openblocks-ce-frontend:latest"
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
            service_name = module.frontend.name
            service_port = module.frontend.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}
