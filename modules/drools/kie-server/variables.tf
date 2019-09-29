variable "name" {}

variable "namespace" {
  default = null
}

variable "replicas" {
  default = 1
}

variable "image" {
  default = "jboss/kie-server"
}

variable "overrides" {
  default = {}
}

variable "controller_url" {}

variable "controller_user" {
  default = "admin"
}

variable "controller_pwd" {
  default = "admin12345"
}

variable "maven_repo_url" {}

variable "maven_user" {
  default = "admin"
}

variable "maven_pwd" {
  default = "admin12345"
}

variable "kie_server_url" {}

variable "kie_server_user" {
  default = "kieserver"
}

variable "kie_server_pwd" {
  default = "kieserver1!"
}
