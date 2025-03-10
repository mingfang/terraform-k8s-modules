variable "name" {
  default = "hadoop-node"
}

variable "namespace" {
  default = ""
}

variable "replicas" {
  default = 1
}

variable "image" {
  default = "registry.rebelsoft.com/hadoop:latest"
}

variable "port_datanode_http" {
  default = 50075
}

variable "port_datanode_ipc" {
  default = 50020
}

variable "port_datanode_stream" {
  default = 50010
}

variable "port_resourcenode_http" {
  default = 8042
}

variable "annotations" {
  default = {
  }
}

variable "node_selector" {
  default = {
  }
}

variable "dns_policy" {
  default = ""
}

variable "priority_class_name" {
  default = ""
}

variable "restart_policy" {
  default = ""
}

variable "scheduler_name" {
  default = ""
}

variable "termination_grace_period_seconds" {
  default = 30
}

variable "session_affinity" {
  default = ""
}

variable "service_type" {
  default = ""
}

/*
service specific variables
*/

variable "resourcemanager" {
}

variable "namenode" {
}

