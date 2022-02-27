variable "name" {}

variable "namespace" {}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name = "cql"
      port = 9042
    },
    {
      name = "intra-node"
      port = 7000
    },
    {
      name = "intra-node-tls"
      port = 7001
    },
    {
      name = "jmx"
      port = 7199
    },
    {
      name = "rpc"
      port = 9160
    },
  ]
}

variable "image" {
  default = "cassandra:4.0.3"
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

variable "resources" {
  default = {
    requests = {
      cpu    = "500m"
      memory = "512Mi"
    }
    limits = {
      memory = "1Gi"
    }
  }
}

variable "storage" {}

variable "storage_class" {}

variable "volume_claim_template_name" {
  default = "pvc"
}

variable "CASSANDRA_CLUSTER_NAME" {
  default = "cassandra"
}
variable "CASSANDRA_DC" {
  default = "dc1"
}
variable "CASSANDRA_RACK" {
  default = "rack1"
}
variable "CASSANDRA_ENDPOINT_SNITCH" {
  default = "GossipingPropertyFileSnitch"
}
