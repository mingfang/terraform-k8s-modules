module "namespace" {
  source    = "../namespace"
  name      = var.namespace
  is_create = var.is_create_namespace
}

# ── CloudNativePG Cluster (replaces old StatefulSet hindsight-db) ──────────
module "hindsight-db" {
  source    = "../../modules/cloudnative-pg-cluster"
  name      = "hindsight-db"
  namespace = module.namespace.name

  image_name = "registry.rebelsoft.com/cloudnative-vchord-suite:18.3-trixie"

  env_map = {
    "POSTGRES_PASSWORD" = var.postgres_password
  }

  instances    = 3
  storage_size = "100Gi"

  postgresql_shared_preload_libraries = ["vchord", "vchord_bm25", "vector", "pg_tokenizer"]

  postgresql_init_schemas = ["bm25_catalog", "tokenizer_catalog"]

  postgresql_hba = ["host all all 0.0.0.0/0 scram-sha-256", "host all all ::/0 scram-sha-256"]

  postgresql_parameters = {
    max_wal_senders = "10"
    search_path     = "\\$user, public, bm25_catalog, tokenizer_catalog"
  }

  pooler = {
    name            = "hindsight-db-pooler"
    max_client_conn = 100
    pool_mode       = "transaction"
    instances       = 1
    pg_hba          = ["host all all 0.0.0.0/0 scram-sha-256", "host all all ::/0 scram-sha-256"]
  }

  bootstrap = {
    database = "hindsight_db"
    owner    = var.postgres_user
    post_init_application_sql = [
      "CREATE EXTENSION IF NOT EXISTS vchord CASCADE;",
      "CREATE EXTENSION IF NOT EXISTS pg_tokenizer CASCADE;",
      "CREATE EXTENSION IF NOT EXISTS vchord_bm25 CASCADE;",
      "SELECT tokenizer_catalog.create_tokenizer('llmlingua2', 'model = \"llmlingua2\"');",
    ]
  }

  resources = {
    requests = {
      cpu    = "2"
      memory = "4Gi"
    }
    limits = {
      memory = "8Gi"
    }
  }
}


module "hindsight" {
  source    = "../../modules/generic-deployment-service"
  name      = var.name
  namespace = module.namespace.name
  image     = "ghcr.io/vectorize-io/hindsight:latest"
  ports_map = { http = 8888, admin = 9999 }

  env_map = {
    HINDSIGHT_API_LLM_PROVIDER       = "openai"
    HINDSIGHT_API_LLM_BASE_URL       = var.hindsight_llm_base_url
    HINDSIGHT_API_LLM_API_KEY        = var.hindsight_llm_api_key
    HINDSIGHT_API_LLM_MODEL          = "gpt-5"
    HINDSIGHT_API_LLM_MAX_CONCURRENT = "1"

    # Database Configuration — use CNPG pooler service
    HINDSIGHT_API_DATABASE_URL = "postgresql://${var.postgres_user}:${var.postgres_password}@${module.hindsight-db.pooler_service_name}.${module.namespace.name}.svc.cluster.local:5432/hindsight_db"

    # Vector and Text Search Extensions
    HINDSIGHT_API_VECTOR_EXTENSION      = "vchord"
    HINDSIGHT_API_TEXT_SEARCH_EXTENSION = "vchord"

    HINDSIGHT_API_OTEL_TRACES_ENABLED         = "false"
    HINDSIGHT_API_OTEL_EXPORTER_OTLP_ENDPOINT = var.otel_exporter_endpoint
    HINDSIGHT_API_OTEL_EXPORTER_OTLP_HEADERS  = var.otel_exporter_headers

    HINDSIGHT_API_LITELLM_API_BASE       = var.hindsight_litellm_api_base
    HINDSIGHT_API_LITELLM_API_KEY        = var.hindsight_litellm_api_key
    HINDSIGHT_API_RERANKER_PROVIDER      = "litellm"
    HINDSIGHT_API_RERANKER_LITELLM_MODEL = "rerank"

    HINDSIGHT_API_FILE_STORAGE_TYPE      = "s3"
    HINDSIGHT_API_FILE_STORAGE_S3_BUCKET = var.s3_bucket
    # HINDSIGHT_API_FILE_STORAGE_S3_ENDPOINT=http://seaweedfs:8333
    HINDSIGHT_API_FILE_STORAGE_S3_REGION            = "us-east-1"
    HINDSIGHT_API_FILE_STORAGE_S3_ACCESS_KEY_ID     = var.s3_access_key_id
    HINDSIGHT_API_FILE_STORAGE_S3_SECRET_ACCESS_KEY = var.s3_secret_access_key
  }
}

resource "k8s_networking_k8s_io_v1_ingress" "admin" {
  metadata {
    annotations = {
      "nginx.ingress.kubernetes.io/server-alias"          = "${var.namespace}-admin.*"
      "nginx.ingress.kubernetes.io/ssl-redirect"          = "true"
      "nginx.ingress.kubernetes.io/proxy-connect-timeout" = "3600"
      "nginx.ingress.kubernetes.io/proxy-read-timeout"    = "3600"
      "nginx.ingress.kubernetes.io/proxy-body-size"       = "10240m"
    }
    name      = var.namespace
    namespace = module.namespace.name
  }
  spec {
    ingress_class_name = "nginx"
    rules {
      host = var.namespace
      http {
        paths {
          backend {
            service {
              name = module.hindsight.name
              port {
                number = module.hindsight.ports_map.admin
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
