variable "name" {}

variable "namespace" {
  default = null
}

variable "replicas" {
  default = 3
}

variable "ports" {
  default = [
    {
      name = "bookie"
      port = 3181
    },
  ]
}

variable "image" {
  default = "apachepulsar/pulsar-all:latest"
}

variable "overrides" {
  default = {}
}

variable storage {}

variable "storage_class" {}

variable "zookeeper" {}

variable "clusterName" {
  default = "local"
}

variable "dbStorage_writeCacheMaxSizeMb" {
  default = 32
}

variable "dbStorage_readAheadCacheMaxSizeMb" {
  default = 32
}

variable PULSAR_MEM {
  default = "-Xms64m -Xmx256m -XX:MaxDirectMemorySize=256m"
}

variable "EXTRA_OPTS" {
  default = ""
}

