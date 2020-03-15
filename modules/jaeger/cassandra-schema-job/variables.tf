variable "name" {
  default = "jaeger-cassandra-schema"
}

variable "namespace" {
  default = null
}

variable "image" {
  default = "jaegertracing/jaeger-cassandra-schema:1.6.0"
}
