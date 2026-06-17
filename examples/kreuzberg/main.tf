# ── Namespace ────────────────────────────────────────────────────────────────
module "namespace" {
  source    = "../namespace"
  name      = var.namespace
  is_create = var.is_create_namespace
}

# ── Persistent Volume Claim ──────────────────────────────────────────────────
resource "k8s_core_v1_persistent_volume_claim" "data" {
  metadata {
    name      = "data"
    namespace = module.namespace.name
  }

  spec {
    access_modes       = ["ReadWriteMany"]
    storage_class_name = var.storage_class
    resources {
      requests = {
        storage = var.storage_size
      }
    }
  }
}

# ── Deployment + Service ────────────────────────────────────────────────────
module "kreuzberg" {
  source    = "../../modules/generic-deployment-service"
  name      = var.name
  namespace = module.namespace.name

  image    = var.image
  replicas = var.replicas

  ports_map = {
    http = var.port
  }

  args    = var.args
  command = var.command

  pvcs = [
    {
      name       = "data"
      mount_path = "/data"
    }
  ]

  env_map = merge(var.env_map, {
    HF_HOME                = "/tmp/huggingface"
    KREUZBERG_CACHE_DIR    = "/tmp"
    KREUZBERG_OCR_LANGUAGE = "eng"
    # KREUZBERG_OCR_BACKEND               = "paddleocr"
    KREUZBERG_VLM_OCR_MODEL             = "openai/gpt-4" #note OPENAI_API_BASE and OPENAI_API_KEY equilvalent for set by caller
    RUST_LOG                            = "info"
    TESSDATA_PREFIX                     = "/usr/share/tesseract-ocr/5/tessdata/"
    KREUZBERG_MAX_MULTIPART_FIELD_BYTES = "524288000"
    KREUZBERG_MAX_REQUEST_BODY_BYTES    = "524288000"
    KREUZBERG_HOST                      = "0.0.0.0"
  })

  resources = {
    requests = {
      cpu    = "250m"
      memory = "64Mi"
    }
  }

  security_context = {
    fs_group = 1000
  }

  node_selector = var.node_selector

  tolerations = [
    {
      key      = "nvidia.com/gpu"
      operator = "Exists"
      effect   = "NoSchedule"
    }
  ]
}

# ── Ingress ──────────────────────────────────────────────────────────────────
resource "k8s_networking_k8s_io_v1_ingress" "this" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"                       = "nginx"
      "nginx.ingress.kubernetes.io/server-alias"          = "${var.namespace}.*"
      "nginx.ingress.kubernetes.io/ssl-redirect"          = "true"
      "nginx.ingress.kubernetes.io/proxy-body-size"       = var.proxy_body_size
      "nginx.ingress.kubernetes.io/proxy-connect-timeout" = var.proxy_connect_timeout
      "nginx.ingress.kubernetes.io/proxy-read-timeout"    = var.proxy_read_timeout
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
              name = module.kreuzberg.name
              port {
                number = module.kreuzberg.ports[0].port
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
