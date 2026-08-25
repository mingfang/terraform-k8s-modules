module "namespace" {
  source    = "../namespace"
  name      = var.namespace
  is_create = var.is_create_namespace
}

module "minio" {
  source    = "../../modules/generic-statefulset-service"
  name      = "minio"
  namespace = module.namespace.name
  image     = "minio/minio:latest"
  args      = ["server", "/data", "--console-address", ":9001"]
  ports     = [{ name = "s3", port = 9000 }]

  env_map = {
    MINIO_ROOT_USER     = var.minio_access_key
    MINIO_ROOT_PASSWORD = var.minio_secret_key
  }

  storage    = var.minio_storage
  mount_path = "/data"
}

module "openobserve" {
  source    = "../../modules/generic-statefulset-service"
  name      = var.name
  namespace = module.namespace.name
  image     = var.image

  ports_map = { http = 5080 }

  env_map = {
    ZO_DATA_DIR = "/data"

    ZO_ROOT_USER_EMAIL    = var.root_user_email
    ZO_ROOT_USER_PASSWORD = var.root_user_password
    ZO_ROOT_USER_TOKEN    = var.root_user_token

    ZO_S3_PROVIDER    = "minio"
    ZO_S3_SERVER_URL  = "http://${module.minio.name}:9000"
    ZO_S3_BUCKET_NAME = "openobserve"
    ZO_S3_REGION_NAME = "us-east-1"
    ZO_S3_ACCESS_KEY  = var.minio_access_key
    ZO_S3_SECRET_KEY  = var.minio_secret_key

    O2_AI_ENABLED         = "true"
    O2_AI_GATEWAY_ENABLED = "true"
    O2_AI_GATEWAY_URL     = var.ai_base_url
    O2_AI_MODEL           = var.ai_model
    O2_AI_API_KEY         = var.ai_api_key
  }

  liveness_probe = {
    initial_delay_seconds = 30
    period_seconds        = 30
    failure_threshold     = 3

    http_get = {
      path = "/healthz"
      port = 5080
    }
  }

  storage    = var.storage
  mount_path = "/data"
}

resource "k8s_batch_v1_job" "bucket_init" {
  metadata {
    name      = "${var.name}-bucket-init"
    namespace = module.namespace.name
  }

  spec {
    backoff_limit              = 3
    active_deadline_seconds    = 60
    ttl_seconds_after_finished = 300

    template {
      metadata {}

      spec {
        restart_policy = "OnFailure"

        containers {
          name  = "mc"
          image = "minio/mc:latest"
          command = [
            "/bin/sh",
            "-c",
            "mc alias set minio http://${module.minio.name}:9000 ${var.minio_access_key} ${var.minio_secret_key} && mc mb --ignore-existing minio/openobserve"
          ]
        }
      }
    }
  }
}

resource "k8s_networking_k8s_io_v1_ingress" "this" {
  metadata {
    annotations = {
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}.*"
      "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
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
              name = module.openobserve.name
              port {
                number = module.openobserve.ports[0].port
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
