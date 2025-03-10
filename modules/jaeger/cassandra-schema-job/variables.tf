variable "name" {
  default = "jaeger-cassandra-schema"
}

variable "namespace" {}

variable "image" {
  default = "jaegertracing/jaeger-cassandra-schema:1.20.0"
}
