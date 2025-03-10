variable "name" {}

variable "namespace" {
  default = null
}

variable "replicas" {
  default = 1
}

variable ports {
  type = list
  default = [
    {
      name = "http"
      port = 5601
    },
  ]
}

variable "image" {
  default = "docker.elastic.co/kibana/kibana:6.5.1"
}

variable "env" {
  type    = list
  default = []
}

variable "annotations" {
  type    = map
  default = {}
}

variable "node_selector" {
  type    = map
  default = {}
}

variable "overrides" {
  default = {}
}

variable "server_name" {
  default = "kibana"
}

variable "server_host" {
  default = "0.0.0.0"
}

variable "elasticsearch_url" {
  default = "http://elasticsearch:9200"
}

variable "xpack_monitoring_ui_container_elasticsearch_enabled" {
  default = "true"
}
