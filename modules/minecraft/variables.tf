variable "name" {}

variable "namespace" {
  default = null
}

variable ports {
  default = [
    {
      name = "minecraft"
      port = 25565
    },
    {
      name = "frontail"
      port = 9001
    },
  ]
}

variable "image" {
  default = "registry.rebelsoft.com/minecraft:latest"
}

variable "env" {
  type    = list
  default = []
}

variable "annotations" {
  type    = map
  default = null
}

variable "node_selector" {
  type    = map
  default = null
}

variable "storage" {}

variable "storage_class_name" {}

variable "volume_claim_template_name" {
  default = "pvc"
}

variable "overrides" {
  default = {}
}

variable "bungeecord" {
  default = false
}