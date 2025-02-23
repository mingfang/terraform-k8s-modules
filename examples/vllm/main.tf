module "namespace" {
  source    = "../namespace"
  name      = var.namespace
  is_create = var.is_create_namespace
}

module "vllm" {
  source    = "../../modules/generic-deployment-service"
  name      = "vllm"
  namespace = module.namespace.name
  image     = "vllm/vllm-openai:latest"
  ports     = [{ name = "http", port = 8000 }]
  replicas  = 1

  args = [
    "--model", "Qwen/Qwen2.5-VL-7B-Instruct",
  ]
  env_map = {
    HUGGING_FACE_HUB_TOKEN = var.HUGGING_FACE_HUB_TOKEN
  }
  resources = {
    limits = {
      "nvidia.com/gpu" = 1
    }
  }
  strategy = {
    type = "Recreate"
  }
  tolerations = [
    {
      key      = "nvidia.com/gpu"
      operator = "Exists"
      effect   = "NoSchedule"
    }
  ]
  volumes = [
    {
      name = "cache"
      host_path = {
        path = "/root/.cache/huggingface/hub"
        type = "DirectoryOrCreate"
      }
      mount_path = "/data"
    }
  ]
}

resource "k8s_networking_k8s_io_v1_ingress" "vllm" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${module.namespace.name}.*"
      "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
    }
    name      = var.name
    namespace = module.namespace.name
  }
  spec {
    rules {
      host = module.namespace.name
      http {
        paths {
          backend {
            service {
              name = module.vllm.name
              port {
                number = module.vllm.ports.0.port
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
