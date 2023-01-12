resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

locals {
  POSTGRES_DB       = "postgres"
  POSTGRES_USER     = "postgres"
  POSTGRES_PASSWORD = "postgres"

  STUDIO_DEFAULT_ORGANIZATION = "Default Organization"
  STUDIO_DEFAULT_PROJECT      = "Default Project"
  SUPABASE_PUBLIC_URL         = "https://${var.namespace}.rebelsoft.com"

  JWT_SECRET       = "your-super-secret-jwt-token-with-at-least-32-characters-long"
  ANON_KEY         = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyAgCiAgICAicm9sZSI6ICJhbm9uIiwKICAgICJpc3MiOiAic3VwYWJhc2UtZGVtbyIsCiAgICAiaWF0IjogMTY0MTc2OTIwMCwKICAgICJleHAiOiAxNzk5NTM1NjAwCn0.dc_X5iR_VP_qT0zsiyj_I_OZ2T9FtRU2BBNWN8Bu4GE"
  SERVICE_ROLE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyAgCiAgICAicm9sZSI6ICJzZXJ2aWNlX3JvbGUiLAogICAgImlzcyI6ICJzdXBhYmFzZS1kZW1vIiwKICAgICJpYXQiOiAxNjQxNzY5MjAwLAogICAgImV4cCI6IDE3OTk1MzU2MDAKfQ.DaYlNEoUrrEn2Ig7tqibS-PHK5vgusbcbo7X36XVt4Q"
}

module "secrets" {
  source    = "../../modules/kubernetes/secret"
  name      = var.namespace
  namespace = k8s_core_v1_namespace.this.metadata.0.name

  from-map = {
    POSTGRES_DB       = base64encode(local.POSTGRES_DB)
    POSTGRES_USER     = base64encode(local.POSTGRES_USER)
    POSTGRES_PASSWORD = base64encode(local.POSTGRES_PASSWORD)
  }
}

module "postgres" {
  source      = "../../modules/postgres"
  name        = "postgres"
  namespace   = k8s_core_v1_namespace.this.metadata.0.name
  annotations = {
    checksum_secrets = module.secrets.checksum
  }
  image    = "postgres:15.1"
  replicas = 1

  storage_class = "cephfs"
  storage       = "1Gi"

  env_map = {
    POSTGRES_USER     = "postgres"
    POSTGRES_PASSWORD = "postgres"
    POSTGRES_DB       = "postgres"
  }
}

module "postgres_init_config" {
  source    = "../../modules/kubernetes/config-map"
  name      = "postgres-init"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  from-dir = "${path.module}/config"
}

module "postgres_init" {
  source    = "../../modules/kubernetes/job"
  name      = "postgres-init"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  image     = "postgres:15.1"

  env_map = {
    PGHOST            = module.postgres.name
    PGUSER            = "postgres"
    PGPASSWORD        = "postgres"
    PGDATABASE        = "postgres"
    POSTGRES_PASSWORD = "postgres"
  }
  configmap = module.postgres_init_config.config_map

  command = [
    "bash",
    "-c",
    <<-EOF
    until pg_isready; do
      echo 'Waiting to start...'
      sleep 5
    done

    cd /config
    psql -v ON_ERROR_STOP=0 -f "0-create-postgres.sql"

    for sql in {00,00}*.sql; do
        echo "$0: running $sql"
        psql -v ON_ERROR_STOP=0 -f "$sql"
    done

    psql -v ON_ERROR_STOP=0 -c "ALTER USER supabase_admin WITH PASSWORD '$POSTGRES_PASSWORD'"

    for sql in {1,2}*.sql; do
        echo "$0: running $sql"
        PGPASSWORD=$POSTGRES_PASSWORD psql -v ON_ERROR_STOP=0 -U supabase_admin -f "$sql"
    done

    for sql in {9,9}*.sql; do
        echo "$0: running $sql"
        psql -v ON_ERROR_STOP=0 -f "$sql"
    done
    EOF
  ]
}

module "postgrest" {
  source    = "../../modules/postgrest"
  name      = "rest"
  namespace = k8s_core_v1_namespace.this.metadata.0.name
  replicas  = 1

  /* https://postgrest.org/en/stable/configuration.html#env-variables-config */
  env_map = {
    PGRST_DB_URI                   = "postgres://authenticator:postgres@${module.postgres.name}:${module.postgres.ports.0.port}/postgres?sslmode=disable"
    PGRST_DB_SCHEMAS               = "public,storage,graphql_public"
    PGRST_DB_ANON_ROLE             = "anon"
    PGRST_JWT_SECRET               = local.JWT_SECRET
    PGRST_DB_USE_LEGACY_GUCS       = "false"
    PGRST_LOG_LEVEL                = "info"
    PGRST_OPENAPI_SERVER_PROXY_URI = "${local.SUPABASE_PUBLIC_URL}/rest/v1"
  }
}

module "gotrue" {
  source    = "../../modules/supabase/gotrue"
  name      = "auth"
  namespace = k8s_core_v1_namespace.this.metadata.0.name
  replicas  = 1

  /* https://github.com/supabase/gotrue/blob/master/example.env */
  env_map = {
    API_EXTERNAL_URL = local.SUPABASE_PUBLIC_URL
    GOTRUE_SITE_URL  = local.SUPABASE_PUBLIC_URL

    GOTRUE_DB_DRIVER       = "postgres"
    GOTRUE_DB_DATABASE_URL = "postgres://supabase_auth_admin:postgres@${module.postgres.name}:${module.postgres.ports.0.port}/postgres?sslmode=disable"

    /* these are need for keycloak integration to work */
    GOTRUE_URI_ALLOW_LIST         = "**" // note: must be two `**` to enable any `redirect_to` url
    GOTRUE_DISABLE_SIGNUP         = "false" // must be enabled for new users to be created after login with IdP
    GOTRUE_JWT_DEFAULT_GROUP_NAME = "authenticated"

    GOTRUE_JWT_SECRET      = local.JWT_SECRET
    GOTRUE_JWT_EXP         = 3600
    GOTRUE_JWT_AUD         = "authenticated"
    GOTRUE_JWT_ADMIN_ROLES = "supabase_admin,service_role"

    #    GOTRUE_SMTP_HOST = "smtp.gmail.com"
    #    GOTRUE_SMTP_PORT = 587
    #    GOTRUE_SMTP_USER = var.GOTRUE_SMTP_USER
    #    GOTRUE_SMTP_PASS = var.GOTRUE_SMTP_PASS

    GOTRUE_EXTERNAL_KEYCLOAK_ENABLED      = "true"
    GOTRUE_EXTERNAL_KEYCLOAK_CLIENT_ID    = var.namespace
    GOTRUE_EXTERNAL_KEYCLOAK_SECRET       = "6b16e48c-8e33-4635-b5ce-10e06ddc90f4"
    GOTRUE_EXTERNAL_KEYCLOAK_REDIRECT_URI = "https://${var.namespace}.rebelsoft.com/auth/v1/callback"
    GOTRUE_EXTERNAL_KEYCLOAK_URL          = "https://keycloak.rebelsoft.com/auth/realms/rebelsoft"

    GOTRUE_LOG_LEVEL = "debug"
  }
}

module "meta" {
  source    = "../../modules/supabase/meta"
  name      = "meta"
  namespace = k8s_core_v1_namespace.this.metadata.0.name
  replicas  = 1

  env_from = [module.secrets.secret_ref]

  env_map = {
    PG_META_DB_HOST     = module.postgres.name
    PG_META_DB_PORT     = module.postgres.ports.0.port
    PG_META_DB_NAME     = local.POSTGRES_DB
    PG_META_DB_USER     = "supabase_admin"
    PG_META_DB_PASSWORD = local.POSTGRES_PASSWORD
  }
}

module "realtime" {
  source    = "../../modules/supabase/realtime"
  name      = "realtime"
  namespace = k8s_core_v1_namespace.this.metadata.0.name
  replicas  = 1

  env_map = {
    DB_NAME     = "postgres"
    DB_USER     = "postgres"
    DB_PASSWORD = "postgres"
    DB_HOST     = module.postgres.name
    DB_PORT     = module.postgres.ports.0.port

    DB_ENC_KEY             = "supabaserealtime"
    DB_AFTER_CONNECT_QUERY = "SET search_path TO _realtime"
    API_JWT_SECRET         = local.JWT_SECRET
    FLY_ALLOC_ID           = "fly123"
    FLY_APP_NAME           = "realtime"
    SECRET_KEY_BASE        = "UpNVntn3cDxHJpq99YMc1T1AQgQpc8kfYTuRgBiYa15BLrx8etQoXz3gZv1/u2oq"
    ERL_AFLAGS             = "-proto_dist inet_tcp"
    ENABLE_TAILSCALE       = "false"
    DNS_NODES              = "''"
  }
}

module "storage" {
  source    = "../../modules/supabase/storage"
  name      = "storage"
  namespace = k8s_core_v1_namespace.this.metadata.0.name
  replicas  = 1

  /* https://github.com/supabase/storage-api/blob/master/.env.sample */
  env_map = {
    ANON_KEY    = local.ANON_KEY
    SERVICE_KEY = local.SERVICE_ROLE_KEY

    PGRST_JWT_SECRET = local.JWT_SECRET
    POSTGREST_URL    = "http://${module.postgrest.name}:${module.postgrest.ports.0.port}"

    DATABASE_URL    = "postgres://supabase_storage_admin:${local.POSTGRES_PASSWORD}@${module.postgres.name}:${module.postgres.ports.0.port}/${local.POSTGRES_DB}"
    FILE_SIZE_LIMIT = 52428800

    /* file storage */
    #        STORAGE_BACKEND           = "file"
    FILE_STORAGE_BACKEND_PATH = "/tmp"

    /* s3 storage */
    STORAGE_BACKEND            = "s3"
    #    GLOBAL_S3_ENDPOINT         = "http://localstack.localstack-example:4566"
    #    GLOBAL_S3_ENDPOINT         = "http://s3-gateway.minio-example:9000"
    GLOBAL_S3_FORCE_PATH_STYLE = "true" //https://github.com/supabase/storage-api/issues/252
    REGION                     = "us-east-1"
    GLOBAL_S3_BUCKET           = "rebelsoft-supabase-example"
    /* test with localstack */
    #    AWS_ACCESS_KEY_ID          = "test"
    #    AWS_SECRET_ACCESS_KEY      = "test"
    # s3 gateway
    #    AWS_ACCESS_KEY_ID          = "mingfang"
    #    AWS_SECRET_ACCESS_KEY      = "mingfang12345"
    #     legionx
    AWS_ACCESS_KEY_ID          = var.AWS_ACCESS_KEY_ID
    AWS_SECRET_ACCESS_KEY      = var.AWS_SECRET_ACCESS_KEY

    /* image transformation */
    ENABLE_IMAGE_TRANSFORMATION = "true"
    IMGPROXY_URL                = "http://imgproxy:5001"

    LOG_LEVEL = "debug"
    # this will become top level folder name in s3
    TENANT_ID = "stub"
  }
}

module "kong_config" {
  source    = "../../modules/kubernetes/config-map"
  name      = "kong-config"
  namespace = k8s_core_v1_namespace.this.metadata.0.name

  from-dir = "${path.module}/kong"
}

module "kong" {
  source    = "../../modules/kong"
  name      = "kong"
  namespace = k8s_core_v1_namespace.this.metadata.0.name
  replicas  = 1

  configmap = module.kong_config.config_map

  env_map = {
    KONG_DATABASE                      = "off"
    KONG_DECLARATIVE_CONFIG            = "/config/kong.yml"
    KONG_DNS_ORDER                     = "LAST,A,CNAME"
    KONG_PLUGINS                       = "request-transformer,key-auth,acl"
    KONG_NGINX_PROXY_PROXY_BUFFER_SIZE = "160k"
    KONG_NGINX_PROXY_PROXY_BUFFERS     = "64 160k"
  }
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "supabase" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"                   = "nginx"
      "nginx.ingress.kubernetes.io/server-alias"      = "${var.namespace}.*"
      "nginx.ingress.kubernetes.io/proxy-buffer-size" = "160k"

      "nginx.ingress.kubernetes.io/enable-cors"        = "true"
      "nginx.ingress.kubernetes.io/cors-allow-headers" = "keep-alive,user-agent,x-requested-with,x-request-id,if-modified-since,cache-control,content-type,range,authorization,apikey,x-client-info,accept-profile,prefer,content-profile,range-unit,x-upsert"
      "nginx.ingress.kubernetes.io/cors-allow-origin"  = "https://*.rebelsoft.com"

    }
    name      = module.kong.name
    namespace = k8s_core_v1_namespace.this.metadata.0.name
  }
  spec {
    rules {
      host = "${module.kong.name}-${var.namespace}"
      http {
        paths {
          backend {
            service_name = module.kong.name
            service_port = module.kong.ports.0.port
          }
          path = "/"
        }
      }
    }
  }
}

module "studio" {
  source    = "../../modules/supabase/studio"
  name      = "studio"
  namespace = k8s_core_v1_namespace.this.metadata.0.name
  replicas  = 1

  command = [
    "bash",
    "-c",
    <<-EOF
    grep -rl "http://localhost:8000" .next | xargs sed -i -e "s|http://localhost:8000|https://supabase-example.rebelsoft.com|"
    ./docker-entrypoint.sh npm run start
    EOF
  ]
  env_from = [module.secrets.secret_ref]
  env_map  = {
    STUDIO_PG_META_URL = "http://${module.meta.name}:${module.meta.ports.0.port}"

    DEFAULT_ORGANIZATION = local.STUDIO_DEFAULT_ORGANIZATION
    DEFAULT_PROJECT      = local.STUDIO_DEFAULT_PROJECT

    SUPABASE_URL        = "http://${module.kong.name}:${module.kong.ports.0.port}"
    SUPABASE_PUBLIC_URL = local.SUPABASE_PUBLIC_URL

    SUPABASE_REST_URL    = "${local.SUPABASE_PUBLIC_URL}/rest/v1/"
    SUPABASE_ANON_KEY    = local.ANON_KEY
    SUPABASE_SERVICE_KEY = local.SERVICE_ROLE_KEY
  }
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "studio" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${module.studio.name}-${var.namespace}.*"
    }
    name      = module.studio.name
    namespace = k8s_core_v1_namespace.this.metadata.0.name
  }
  spec {
    rules {
      host = "${module.studio.name}-${var.namespace}"
      http {
        paths {
          backend {
            service_name = module.studio.name
            service_port = module.studio.ports.0.port
          }
          path = "/"
        }
      }
    }
  }
}

