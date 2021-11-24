variable "name" {}

variable "namespace" {}

variable "replicas" {
  default = 1
}

variable "image" {
  default = "stackstorm/st2sensorcontainer:latest"
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
variable "stackstorm_packs_configs_pvc_name" {}
variable "stackstorm_packs_pvc_name" {}
variable "stackstorm_virtualenvs_pvc_name" {}
