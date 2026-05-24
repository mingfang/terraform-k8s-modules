variable "name" {
  default = "citus"
}

variable "namespace" {
  default = "citus-example"
}

variable "is_create_namespace" {
  default = true
}

variable "image" {
  default = "registry.rebelsoft.com/postgres-vectorchord:18.3-trixie"
}

variable "replicas" {
  default = 3
}