variable "name" {}

variable "namespace" {
  default = null
}

/*
First replicas will be coordinator only.
The other replicas will be workers.
*/
variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name = "http"
      port = 8081
    },
  ]
}

variable "image" {
  default = "apachepulsar/pulsar-all:latest"
}

variable "overrides" {
  default = {}
}

/*
If discovery_uri is empty then start as Presto coordinator,
else start as Presto worker.
*/
variable "discovery_uri" {
  default = ""
}

variable "pulsar" {}

variable "zookeeper" {}

variable PULSAR_MEM {
  default = "-Xms64m -Xmx128m -XX:MaxDirectMemorySize=128m"
}

variable "EXTRA_OPTS" {
  default = ""
}
