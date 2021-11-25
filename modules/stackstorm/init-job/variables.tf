variable "name" {}

variable "namespace" {}

variable "image" {
  default = "registry.rebelsoft.com/st2actionrunner:latest"
}

variable "annotations" {
  default = {}
}

variable "config_map" {}
variable "config_map_rbac_assignments" {}
variable "stackstorm_packs_configs_pvc_name" {}
variable "stackstorm_packs_pvc_name" {}
