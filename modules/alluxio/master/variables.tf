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
      name = "tcp-master"
      port = 19998
    },
    {
      name = "http-master"
      port = 19999
    },
    {
      name = "tcp-jobmaster"
      port = 20001
    },
    {
      name = "http-jobmaster"
      port = 20002
    },
  ]
}

variable "image" {
  default = "alluxio/alluxio:2.0.1"
}

variable "overrides" {
  default = {}
}

variable "extra_alluxio_java_opts" {
  default = ""
}