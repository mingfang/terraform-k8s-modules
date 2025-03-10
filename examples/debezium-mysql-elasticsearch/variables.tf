variable "name" {
  default = "debezium-mysql-es"
}

variable "namespace" {
  default = "debezium-mysql-es"
}

//comma separated list of tables to sync
variable "topics" {
  default = "customers"
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
