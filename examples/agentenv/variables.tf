variable "name" {
  default = "agentenv"
}

variable "namespace" {
  default = "agentenv-example"
}

variable "is_create_namespace" {
  default = true
}

# The runtime image is prebuilt and published to GHCR:
#   https://github.com/kvcache-ai/AgentENV/pkgs/container/aenv-server
# The scheduler and gateway images are NOT published — build them from the
# AgentENV repo (`make k8s-build`), push to your registry, and override below.
variable "runtime_image" {
  default = "registry.rebelsoft.com/agentenv-agentenv:latest"
}

variable "scheduler_image" {
  default = "registry.rebelsoft.com/agentenv-scheduler:latest"
}

variable "gateway_image" {
  default = "registry.rebelsoft.com/agentenv-gateway:latest"
}

# Compose: ${SANDBOX_PROXY_DOMAINS:-}. Forwarded to both the gateway
# (GATEWAY_SANDBOX_PROXY_DOMAINS) and the runtime nodes (AENV_SANDBOX_PROXY_DOMAINS).
variable "sandbox_proxy_domains" {
  default = ""
}

# Runtime pods are privileged DaemonSet pods that need host /dev (KVM + ublk)
# and host /var/lib/aenv. Pin them to KVM-capable nodes, e.g.:
#   kubectl label node <n> node-type=epyc
# then set the selector in .auto.tfvars. Defaults to {} (any node).
variable "runtime_node_selector" {
  default = {}
}
