module "namespace" {
  source    = "../namespace"
  name      = var.namespace
  is_create = var.is_create_namespace
}

locals {
  # https://docs.vllm.ai/projects/recipes/en/latest/Qwen/Qwen3.5.html
  qwen3_6 = [
    "Qwen/Qwen3.6-35B-A3B-FP8",
    "--enable-auto-tool-choice",
    "--tool-call-parser", "qwen3_coder", # or qwen3_xml
    "--reasoning-parser", "qwen3",
    "--default-chat-template-kwargs", jsonencode({ "enable_thinking" : true, "preserve_thinking" : true }),
    "--speculative-config", jsonencode({ "method" : "mtp", "num_speculative_tokens" : 2 }),
    # "--language-model-only",
    # "--mm-encoder-tp-mode", "data",
    # "--mm-processor-cache-type", "shm"
  ]

  qwen3_6_27b = [
    "Qwen/Qwen3.6-27B-FP8",
    "--enable-auto-tool-choice",
    "--tool-call-parser", "qwen3_coder", # or qwen3_xml
    "--reasoning-parser", "qwen3",
    "--default-chat-template-kwargs", jsonencode({ "enable_thinking" : true, "preserve_thinking" : true }),
    "--speculative-config", jsonencode({ "method" : "mtp", "num_speculative_tokens" : 2 }),
  ]
}

module "vllm" {
  source    = "../../modules/generic-deployment-service"
  name      = "vllm"
  namespace = module.namespace.name
  image     = "vllm/vllm-openai:v0.23.0"
  ports_map = { http = 8000 }
  replicas  = 1

  args = concat(
    local.qwen3_6,
    [
      "--trust-remote-code", # some models needs it but ok to set for all
      "--served-model-name", "gpt-5", "gpt-5.1", "gpt-4", "gpt-4.1", "gpt",
      "--gpu_memory_utilization", "0.84",
      "--max_model_len", "200k", # new in vllm v14, auto set the max fit to GPU memory
      # "--disable-cascade-attn",  # for A100
      "--kv-cache-dtype", "fp8", # for A100
      # "--kv-cache-dtype", "turboquant_4bit_nc",
      "--dtype", "half", # for A100
      "--enable-prefix-caching",
      "--enable-chunked-prefill",
      "--mamba-cache-mode", "align",
      "--max-num-batched-tokens", "2128", # AssertionError: In Mamba cache align mode, block_size (2112) must be <= max_num_batched_tokens (2048).

      # native layer 2 cache
      "--kv-offloading-backend", "native",
      "--kv-offloading-size", "100",
      # "--kv-transfer-config", jsonencode({
      #   "kv_connector" : "SimpleCPUOffloadConnector",
      #   "kv_connector_extra_config": {"lazy_offload": false},
      #   "kv_role" : "kv_both",
      # }),


    ],
  )

  env_map = merge(
    {
      # VLLM_ATTENTION_BACKEND = "FLASH_ATTN"
      # VLLM_USE_DEEP_GEMM = "0",
      # VLLM_USE_TRTLLM_ATTENTION = "0",
      # VLLM_FLASH_ATTN_VERSION = "2"
    },
    {
      HUGGING_FACE_HUB_TOKEN = var.HUGGING_FACE_HUB_TOKEN
    }
  )

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
        path = "/root/.cache"
        type = "DirectoryOrCreate"
      }
      mount_path = "/root/.cache"
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

resource "k8s_networking_k8s_io_v1_ingress" "vllm" {
  metadata {
    annotations = {
      "nginx.ingress.kubernetes.io/server-alias"          = "${module.namespace.name}.*"
      "nginx.ingress.kubernetes.io/ssl-redirect"          = "true"
      "nginx.ingress.kubernetes.io/proxy-connect-timeout" = "3600"
      "nginx.ingress.kubernetes.io/proxy-read-timeout"    = "3600"
      "nginx.ingress.kubernetes.io/proxy-body-size"       = "10240m"
    }
    name      = var.name
    namespace = module.namespace.name
  }
  spec {
    ingress_class_name = "nginx"
    rules {
      host = module.namespace.name
      http {
        paths {
          backend {
            service {
              name = module.vllm.name
              port {
                number = module.vllm.ports_map.http
              }
            }
          }
          path      = "/"
          path_type = "ImplementationSpecific"
        }
        paths {
          backend {
            service {
              name = module.embedding.name
              port {
                number = module.embedding.ports_map.http
              }
            }
          }
          path      = "/v1/embeddings"
          path_type = "ImplementationSpecific"
        }
        paths {
          backend {
            service {
              name = module.rerank.name
              port {
                number = module.rerank.ports_map.http
              }
            }
          }
          path      = "/v1/rerank"
          path_type = "ImplementationSpecific"
        }
      }
    }
  }
}


/*
curl https://vllm-example.rebelsoft.com/v1/chat/completions \
    -H "Content-Type: application/json" \
    -d '{
        "model": "gpt-5",
        "messages": [
            {"role": "system", "content": "You are a helpful assistant."},
            {"role": "user", "content": "Who won the world series in 2020?"}
        ]
    }' -s | jq .
*/


/*
curl https://vllm-example.rebelsoft.com/v1/chat/completions \
    -H "Content-Type: application/json" \
    -d '{
      "model": "gpt-5",
      "messages": [
        {"role": "user", "content": "In the heart of Eldoria, an ancient land of boundless magic and mysterious creatures,
lies the long-forgotten city of Aeloria. Once a beacon of knowledge and power, Aeloria was buried
beneath the shifting sands of time, lost to the world for centuries. You are an intrepid explorer, known
for your unparalleled curiosity and courage, who has stumbled upon an ancient map hinting that Aeloria
holds a secret so profound that it has the potential to reshape the very fabric of reality. Your journey
will take you through treacherous deserts, enchanted forests, and across perilous mountain ranges.
Your Task: Character Background: Develop a detailed background for your character. Describe their
motivations for seeking out Aeloria, their skills and weaknesses, and any personal connections to the
ancient city or its legends. Are they driven by a quest for knowledge, or a search for lost family? A clue is hidden."
    }
    ],
    "stream":false,
    "max_tokens": 30
  }'
*/
