variable "name" {}

variable "namespace" {}

variable "replicas" {
  default = 1
}

variable ports {
  default = [
    {
      name = "tcp"
      port = 9092
    },
  ]
}

variable image {
  default = "confluentinc/cp-enterprise-kafka:5.5.1"
}

variable "env" {
  default = []
}

variable "annotations" {
  default = {}
}

variable "node_selector" {
  default = {}
}

variable "storage" {}

variable "storage_class" {}

variable "volume_claim_template_name" {
  default = "pvc"
}

variable "overrides" {
  default = {}
}

variable "KAFKA_ZOOKEEPER_CONNECT" {
  description = "Zookeeper URL, e.g. zookeeper:2181"
}

variable "KAFKA_LOG4J_LOGGERS" {
  default = "kafka.controller=INFO,kafka.producer.async.DefaultEventHandler=INFO,state.change.logger=INFO"
}

variable "KAFKA_METRIC_REPORTERS" {
  default = "io.confluent.metrics.reporter.ConfluentMetricsReporter"
}

