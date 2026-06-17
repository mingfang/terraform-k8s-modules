module "namespace" {
  source    = "../namespace"
  name      = var.namespace
  is_create = var.is_create_namespace
}

# ── CloudNativePG Cluster (replaces old StatefulSet hindsight-db) ──────────
module "hindsight-db" {
  source              = "../citus"
  name                = "hindsight-db"
  namespace           = module.namespace.name
  is_create_namespace = false

  username             = var.postgres_user
  password             = var.postgres_password
  database             = "hindsight_db"

  replicas            = 3
  coordinator_storage = "10Gi"
  worker_storage      = "100Gi"

  # shared_preload_libraries = "citus,vchord,vchord_bm25,vector,pg_tokenizer"
  # search_path = "\\$user, public, bm25_catalog, tokenizer_catalog, vectors"
}

locals {
  shared_env_map = {
    HINDSIGHT_API_LLM_PROVIDER          = "openai"
    HINDSIGHT_API_LLM_BASE_URL          = var.hindsight_llm_base_url
    HINDSIGHT_API_LLM_API_KEY           = var.hindsight_llm_api_key
    HINDSIGHT_API_LLM_MODEL             = "gpt-5"
    HINDSIGHT_API_LLM_MAX_CONCURRENT    = "1"
    HINDSIGHT_API_SKIP_LLM_VERIFICATION = "true"

    # Database Configuration — use CNPG pooler service
    HINDSIGHT_API_DATABASE_URL = "postgresql://${var.postgres_user}:${var.postgres_password}@coordinator.${module.namespace.name}.svc.cluster.local:5432/hindsight_db"

    # Vector and Text Search Extensions
    HINDSIGHT_API_VECTOR_EXTENSION      = "pgvectorscale"
    HINDSIGHT_API_TEXT_SEARCH_EXTENSION = "pg_search"

    HINDSIGHT_API_OTEL_TRACES_ENABLED         = "false"
    HINDSIGHT_API_OTEL_EXPORTER_OTLP_ENDPOINT = var.otel_exporter_endpoint
    HINDSIGHT_API_OTEL_EXPORTER_OTLP_HEADERS  = var.otel_exporter_headers

    HINDSIGHT_API_LITELLM_API_BASE       = var.hindsight_litellm_api_base
    HINDSIGHT_API_LITELLM_API_KEY        = var.hindsight_litellm_api_key
    HINDSIGHT_API_RERANKER_PROVIDER      = "litellm"
    HINDSIGHT_API_RERANKER_LITELLM_MODEL = "rerank"
    # HINDSIGHT_API_EMBEDDINGS_PROVIDER      = "litellm"
    # HINDSIGHT_API_EMBEDDINGS_LITELLM_MODEL = "text-embedding-3-small"

    HINDSIGHT_API_FILE_STORAGE_TYPE                 = "s3"
    HINDSIGHT_API_FILE_STORAGE_S3_BUCKET            = var.s3_bucket
    HINDSIGHT_API_FILE_STORAGE_S3_REGION            = "us-east-1"
    HINDSIGHT_API_FILE_STORAGE_S3_ACCESS_KEY_ID     = var.s3_access_key_id
    HINDSIGHT_API_FILE_STORAGE_S3_SECRET_ACCESS_KEY = var.s3_secret_access_key
    # HINDSIGHT_API_FILE_STORAGE_S3_ENDPOINT=http://seaweedfs:8333
  }
}

module "hindsight" {
  source    = "../../modules/generic-deployment-service"
  name      = var.name
  namespace = module.namespace.name
  image     = "ghcr.io/vectorize-io/hindsight:latest"
  ports_map = { http = 8888, admin = 9999 }

  env_map = merge(local.shared_env_map, {
    HINDSIGHT_API_WORKER_ENABLED = "false"
  })
}

module "hindsight-worker" {
  source    = "../../modules/generic-statefulset-service"
  name      = "${var.name}-worker"
  namespace = module.namespace.name
  image     = "ghcr.io/vectorize-io/hindsight:latest"
  ports_map = { http = 8888, admin = 9999 }
  replicas  = 2

  env_map = merge(local.shared_env_map, {
    HINDSIGHT_API_WORKER_ENABLED = "true"
  })
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
