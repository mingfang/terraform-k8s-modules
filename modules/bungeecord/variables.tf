variable "name" {}

variable "namespace" {
  default = null
}

variable ports {
  default = [
    {
      name = "bungeecord"
      port = 25565
    },
  ]
}

variable "image" {
  default = "registry.rebelsoft.com/bungeecord:latest"
}

variable "env" {
  default = []
}

variable "annotations" {
  default = {}
}

variable "node_selector" {
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

variable "priorities" {
  default = [
    "lobby"
  ]
}

variable "servers" {
  default = {
    lobby = {
      motd       = "Just another BungeeCord - Forced Host"
      address    = "lobby:25565"
      restricted = false
    }
  }
}