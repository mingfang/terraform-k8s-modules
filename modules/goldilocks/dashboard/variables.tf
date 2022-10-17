variable "name" {
  default = "goldilocks-dashboard"
}

variable "namespace" {}

variable "image" {
  default = "us-docker.pkg.dev/fairwinds-ops/oss/goldilocks:v4"
}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name = "tcp"
      port = 8080
    },
  ]
}

variable "command" {
  default = ["/goldilocks"]
}
variable "args" {
  default = ["dashboard", "--on-by-default", "--exclude-containers=linkerd-proxy,istio-proxy", "-v3"]

}

variable "env" {
  default = []
}
variable "env_map" {
  default = {}
}
variable "env_file" {
  default = null
}
variable "env_from" {
  default = []
}

variable "annotations" {
  default = {}
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


variable "overrides" {
  default = {}
}

variable "configmap" {
  default = null
}

variable "pvc" {
  default = null
}

variable "mount_path" {
  default     = "/data"
  description = "pvc mount path"
}
