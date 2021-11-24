variable "name" {}

variable "namespace" {}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name = "http"
      port = 9101
    },
  ]
}

variable "image" {
  default = "stackstorm/st2api:latest"
}

variable "env" {
  default = []
}

variable "annotations" {
  default = {}
}

variable "overrides" {
  default = {}
}

variable "config_map" {}
variable "config_map_rbac_assignments" {}
variable "stackstorm_keys_pvc_name" {}
variable "stackstorm_packs_configs_pvc_name" {}
variable "stackstorm_packs_pvc_name" {}

variable "ST2_AUTH_URL" {}
variable "ST2_API_URL" {}
variable "ST2_STREAM_URL" {}

