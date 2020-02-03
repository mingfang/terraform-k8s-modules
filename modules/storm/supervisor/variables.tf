variable "name" {}

variable "namespace" {
  default = null
}

variable "replicas" {
  default = 1
}

variable "port" {
  default = 80
}

variable "image" {
  default = "registry.rebelsoft.com/storm:latest"
}

variable "overrides" {
  default = {}
}

variable "storm_zookeeper_servers" {
  type = list
}

variable nimbus_seeds {
  type = list
}

variable "supervisor_slots_ports" {
  type = list
}