variable "name" {
  default = "kreuzberg"
}

variable "namespace" {
  default = "kreuzberg-example"
}

variable "is_create_namespace" {
  default = true
}

variable "image" {
  default = "ghcr.io/kreuzberg-dev/kreuzberg:latest"
}

variable "replicas" {
  default = 3
}

variable "port" {
  default = 8000
}

variable "args" {
  default = []
}

variable "command" {
  default = []
}

variable "env_map" {
  type    = map(string)
  default = {}
}

variable "storage_size" {
  default = "1Gi"
}

variable "storage_class" {
  default = "cephfs-csi"
}

variable "node_selector" {
  default = {
  }
}

variable "proxy_body_size" {
  default = "10240m"
}

variable "proxy_connect_timeout" {
  default = "3600"
}

variable "proxy_read_timeout" {
  default = "3600"
}
