variable "name" {
  type    = string
  default = "elasticsearch"
}

variable "namespace" {
  type = string
}

variable "image" {
  type    = string
  default = "docker.elastic.co/elasticsearch/elasticsearch:7.17.0"
}

variable "replicas" {
  type    = number
  default = 1
}

variable "ports" {
  default = [
    {
      name = "http"
      port = 9200
    },
  ]
}

variable "command" {
  type    = list(string)
  default = null
}

variable "args" {
  type    = list(string)
  default = null
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
      cpu    = "1"
      memory = "3Gi"
    }
    limits = {
      memory = "4Gi"
    }
  }
}

variable "service_account_name" {
  type    = string
  default = null
}

variable "overrides" {
  default = {}
}

variable "configmap" {
  default = null
}

variable "configmap_mount_path" {
  type = string
  default = "/config"
}

variable "post_start_command" {
  type    = list(string)
  default = null
}

variable "secret" {
  default     = null
  description = "secret containing ca.crt, tls.crt, and tls.key to enable TLS"
}

variable "storage" {
  type    = string
  default = null
}

variable "storage_class" {
  type=string
  default = null
}

variable "volume_claim_template_name" {
  type=string
  default = "pvc"
}

variable "mount_path" {
  type    = string
  default = "/data"
  description = "pvc mount path"
}

variable "ES_JAVA_OPTS" {
  default = ""
}
