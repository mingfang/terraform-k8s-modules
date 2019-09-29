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
      name = "http"
      port = 8080
    },
  ]
}

variable "image" {
  default = "apachepulsar/pulsar-all:latest"
}

variable "overrides" {
  default = {}
}

variable "configurationStoreServers" {}

variable "clusterName" {
  default = "local"
}

variable PULSAR_MEM {
  default = "-Xms16m -Xmx64m -XX:MaxDirectMemorySize=128m"
}

variable "EXTRA_OPTS" {
  default = ""
}
