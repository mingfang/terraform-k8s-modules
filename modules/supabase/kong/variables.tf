variable "name" {
  default = "kong"
}

variable "namespace" {}

variable "ports" {
  default = [
    {
      name = "http"
      port = 8000
    },
    {
      name = "https"
      port = 8443
    },
  ]
}

variable "replicas" {
  default = 1
}

variable "image" {
  default = "registry.rebelsoft.com/supabase-kong"
}

variable "env" {
  default = []
}

variable "annotations" {
  default = {}
}

variable "resources" {
  default = {
    requests = {
      cpu    = "100m"
      memory = "128Mi"
    }
  }
}

variable "overrides" {
  default = {}
}

variable "KONG_DECLARATIVE_CONFIG" {
  default = "/var/lib/kong/kong.yml"
}
variable "KONG_PLUGINS" {
  default = "request-transformer,cors,key-auth,http-log"
}

