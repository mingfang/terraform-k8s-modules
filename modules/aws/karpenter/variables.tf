variable "name" {}

variable "namespace" {}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name = "http"
      port = 8080
    },
  ]
}

variable "image" {
  default = "public.ecr.aws/karpenter/controller:v0.5.1@sha256:f992d8ae64408a783b019cd354265995fa3dd4445f22d793b0f8d520209a3e42"
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

variable "CLUSTER_NAME" {}

variable "CLUSTER_ENDPOINT" {
  default = "https://kubernetes.default:443"
}
