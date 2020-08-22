resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

locals {
  env_forward_proxy = [
    {
      name  = "PROXY_CONFIG_URL_REMAP_REMAP_REQUIRED"
      value = 0
    },
    {
      name  = "PROXY_CONFIG_REVERSE_PROXY_ENABLED"
      value = 0
    },
    {
      name  = "PROXY_CONFIG_HTTP_PARENT_PROXY_ROUTING_ENABLE"
      value = 1
    },
  ]

  env_diags_output = [
    {
      name  = "PROXY_CONFIG_DIAGS_OUTPUT_STATUS"
      value = "O"
    },
    {
      name  = "PROXY_CONFIG_DIAGS_OUTPUT_NOTE"
      value = "O"
    },
    {
      name  = "PROXY_CONFIG_DIAGS_OUTPUT_WARNING"
      value = "O"
    },
    {
      name  = "PROXY_CONFIG_DIAGS_OUTPUT_ERROR"
      value = "E"
    },
    {
      name  = "PROXY_CONFIG_DIAGS_OUTPUT_FATAL"
      value = "E"
    },
    {
      name  = "PROXY_CONFIG_DIAGS_OUTPUT_ALERT"
      value = "E"
    },
    {
      name  = "PROXY_CONFIG_DIAGS_OUTPUT_EMERGENCY"
      value = "E"
    },
  ]
}

module "trafficserver" {
  source    = "../../modules/trafficserver"
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  env = concat(
    local.env_forward_proxy,
    local.env_diags_output,
  )
  // trafficserver will not work with ingress
  host_port = 8080
  overrides = {
    node_selector = {
      host = "ripper2",
    }
  }
}