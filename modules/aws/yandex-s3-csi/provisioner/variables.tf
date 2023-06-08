variable "name" {
  type    = string
  default = "provisioner"
}

variable "namespace" {
  type = string
}

variable "image" {
  type    = string
  default = "quay.io/k8scsi/csi-provisioner:v2.1.0"
}

variable "csi_image" {
  type    = string
  default = "cr.yandex/crp9ftr22d26age3hulg/csi-s3:0.35.0"
}

variable "replicas" {
  type    = number
  default = 1
}

variable "command" {
  type    = list(string)
  default = []
}

variable "env" {
  type    = list(object({ name = string, value = string }))
  default = []
}

variable "env_map" {
  type    = map
  default = {}
}

variable "env_file" {
  type    = string
  default = null
}

variable "env_from" {
  type    = list(object({
    prefix = string,
    secret_ref = object({
      name = string,
    })
  }))
  default = []
}

variable "annotations" {
  type    = map
  default = {}
}

variable "image_pull_secrets" {
  type    = list(object({ name = string, value = string }))
  default = []
}

variable "node_selector" {
  default = {}
}

variable "resources" {
  default = {
    requests = {
      cpu    = "250m"
      memory = "64Mi"
    }
  }
}

variable "post_start_command" {
  type    = list(string)
  default = null
}

variable "overrides" {
  default = {}
}
