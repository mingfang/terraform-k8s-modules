variable "name" {}

variable "namespace" {
  default = null
}

variable "replicas" {
  default = 1
}

variable "image" {
  default = "jboss/kie-server:7.27.0.Final"
}

variable "overrides" {
  default = {}
}

//requires websocket, ws://workbench:8080/business-central/websocket/controller
variable "controller_url" {}

//user must have rest-all role
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

variable "kie_server_user" {
  default = "kieserver"
}

variable "kie_server_pwd" {
  default = "kieserver1!"
}

//save value as the Server Template or Server Configuration in the Workbench
variable "kie_server_id" {
  default = "default"
}

