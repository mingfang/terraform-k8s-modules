variable "name" {
  default = "debezium-postgres-es"
}

variable "namespace" {
  default = "debezium-postgres-es"
}

//comma separated list of tables to sync
variable "topics" {
  default = "musicgroup,musicalbum,musicrecording"
}

//The IP address of any node
variable "ingress_host" {
  default = "192.168.2.146"
}

variable "node_port_http" {
  default = "30090"
}

variable "node_port_https" {
  default = "30091"
}
