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
      name = "http"
      port = 8080
    },
    {
      name = "pulsar"
      port = 6650
    },
  ]
}

variable "image" {
  default = "apachepulsar/pulsar-all:latest"
}

variable "overrides" {
  default = {}
}

variable "storage" {}

variable "storage_class" {}

variable "zookeeper" {}

variable "configurationStoreServers" {}

variable "clusterName" {
  default = "local"
}

variable "managedLedgerDefaultEnsembleSize" {
  default = 1
}

variable "managedLedgerDefaultWriteQuorum" {
  default = 1
}

variable "managedLedgerDefaultAckQuorum" {
  default = 1
}

variable "functionsWorkerEnabled" {
  default = true
}

variable "PF_pulsarFunctionsCluster" {
  default = "local"
}

variable "PULSAR_MEM" {
  default = "-Xms64m -Xmx128m -XX:MaxDirectMemorySize=128m"
}

variable "EXTRA_OPTS" {
  default = ""
}
