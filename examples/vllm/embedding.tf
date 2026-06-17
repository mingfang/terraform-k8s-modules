# vLLM Embedding — Qwen3-Embedding-0.6B
module "embedding" {
  source    = "../../modules/generic-deployment-service"
  name      = "embedding"
  namespace = module.namespace.name
  image     = "vllm/vllm-openai:latest"
  ports_map = { http = 8000 }
  replicas  = 1

  args = [
    "Qwen/Qwen3-Embedding-0.6B",
    "--served-model-name", "text-embedding-3-small",
    "--gpu_memory_utilization", "0.03",
    "--max_model_len", "2k",
    "--max_num_seqs", "1",
    "--trust-remote-code",
    "--hf_overrides", "{\"matryoshka_dimensions\":[768]}",
  ]

  env_map = {
    HUGGING_FACE_HUB_TOKEN = var.HUGGING_FACE_HUB_TOKEN
    LD_LIBRARY_PATH        = "/usr/local/nvidia/lib64:/usr/local/nvidia/lib:/usr/lib/x86_64-linux-gnu"
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

# Ingress — Embedding (standalone)
resource "k8s_networking_k8s_io_v1_ingress" "embedding" {
  metadata {
    annotations = {
      "nginx.ingress.kubernetes.io/server-alias"      = "embedding-${module.namespace.name}.*"
      "nginx.ingress.kubernetes.io/ssl-redirect"      = "true"
      "nginx.ingress.kubernetes.io/proxy-connect-timeout" = "3600"
      "nginx.ingress.kubernetes.io/proxy-read-timeout"    = "3600"
      "nginx.ingress.kubernetes.io/proxy-body-size"       = "10240m"
    }
    name      = "embedding-${var.name}"
    namespace = module.namespace.name
  }
  spec {
    ingress_class_name = "nginx"
    rules {
      host = "embedding-${module.namespace.name}"
      http {
        paths {
          backend {
            service {
              name = module.embedding.name
              port {
                number = module.embedding.ports_map.http
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
