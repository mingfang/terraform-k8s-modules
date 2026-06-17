# vLLM Image — Z-Image-Turbo
module "image" {
  source    = "../../modules/generic-deployment-service"
  name      = "image"
  namespace = module.namespace.name
  image     = "vllm/vllm-omni:v0.16.0"
  ports_map = { http = 8000 }
  replicas  = 0

  command = ["sh", "-c", "vllm serve \\\nTongyi-MAI/Z-Image-Turbo \\\n--omni \\\n--max_model_len=1k \\\n--enable_cpu_offload \\\n--vae-use-slicing --vae-use-tiling \\\n--gpu_memory_utilization=0.2\n"]

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

# Ingress — Image (standalone)
resource "k8s_networking_k8s_io_v1_ingress" "image" {
  metadata {
    annotations = {
      "nginx.ingress.kubernetes.io/server-alias"      = "image-${module.namespace.name}.*"
      "nginx.ingress.kubernetes.io/ssl-redirect"      = "true"
      "nginx.ingress.kubernetes.io/proxy-connect-timeout" = "3600"
      "nginx.ingress.kubernetes.io/proxy-read-timeout"    = "3600"
      "nginx.ingress.kubernetes.io/proxy-body-size"       = "10240m"
    }
    name      = "image-${var.name}"
    namespace = module.namespace.name
  }
  spec {
    ingress_class_name = "nginx"
    rules {
      host = "image-${module.namespace.name}"
      http {
        paths {
          backend {
            service {
              name = module.image.name
              port {
                number = module.image.ports_map.http
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
