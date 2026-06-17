# vLLM Rerank — Qwen3-Reranker-0.6B
module "rerank" {
  source    = "../../modules/generic-deployment-service"
  name      = "rerank"
  namespace = module.namespace.name
  image     = "vllm/vllm-openai:latest"
  ports_map = { http = 8000 }
  replicas  = 1

  args = [
    "Qwen/Qwen3-Reranker-0.6B",
    "--runner", "pooling",
    "--served-model-name", "rerank",
    "--gpu_memory_utilization", "0.04",
    "--max_model_len", "4k",
    "--trust-remote-code",
  ]

  env_map = {
    HUGGING_FACE_HUB_TOKEN = var.HUGGING_FACE_HUB_TOKEN
  }

  resources = {
    requests = {
      cpu    = "250m"
      memory = "64Mi"
    }
  }

  volumes = [
    {
      name = "cache"
      host_path = {
        path = "/root/.cache/huggingface/hub"
        type = "DirectoryOrCreate"
      }
      mount_path = "/root/.cache/huggingface/hub"
    },
    {
      name = "shm"
      empty_dir = {
        medium     = "Memory"
        size_limit = "8Gi"
      }
      mount_path = "/dev/shm"
    },
  ]
}

# Ingress — Rerank (standalone)
resource "k8s_networking_k8s_io_v1_ingress" "rerank" {
  metadata {
    annotations = {
      "nginx.ingress.kubernetes.io/server-alias"      = "rerank-${module.namespace.name}.*"
      "nginx.ingress.kubernetes.io/ssl-redirect"      = "true"
      "nginx.ingress.kubernetes.io/proxy-connect-timeout" = "3600"
      "nginx.ingress.kubernetes.io/proxy-read-timeout"    = "3600"
      "nginx.ingress.kubernetes.io/proxy-body-size"       = "10240m"
    }
    name      = "rerank-${var.name}"
    namespace = module.namespace.name
  }
  spec {
    ingress_class_name = "nginx"
    rules {
      host = "rerank-${module.namespace.name}"
      http {
        paths {
          backend {
            service {
              name = module.rerank.name
              port {
                number = module.rerank.ports_map.http
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
