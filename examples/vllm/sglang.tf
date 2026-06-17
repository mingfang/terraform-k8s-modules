# SGLang — Coder model
module "sglang" {
  source    = "../../modules/generic-deployment-service"
  name      = "sglang"
  namespace = module.namespace.name
  image     = "lmsysorg/sglang:latest"
  ports_map = { http = 8000 }
  replicas  = 0

  command = ["sglang", "serve"]

  args = [
    "--model-path", "cyankiwi/Qwen3-Coder-Next-AWQ-4bit",
    "--host", "0.0.0.0",
    "--port", "8000",
    "--context-length", "200000",
    "--mem-fraction-static", "0.67",
    "--cpu-offload-gb", "40",
    "--mamba-full-memory-ratio", "0.15",
    "--kv-cache-dtype", "fp8_e5m2",
    "--attention-backend", "triton",
    "--trust-remote-code",
    "--served-model-name", "gpt-5 gpt-5.1 gpt-4 gpt-4.1 gpt",
    "--disable-cuda-graph",
    "--disable-overlap-schedule",
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
      mount_path = "/root/.cache/huggingface/hub"
    },
    {
      name = "shm"
      empty_dir = {
        medium     = "Memory"
        size_limit = "32Gi"
      }
      mount_path = "/dev/shm"
    },
  ]
}
