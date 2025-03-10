variable "name" {}

variable "namespace" {
  default = null
}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name : "grpc"
      port : 48555
    },
  ]
}

variable "image" {
  default = "graknlabs/grakn:1.5.9"
}

variable "overrides" {
  default = {}
}

variable "cassandra_host" {}
