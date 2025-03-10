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
      port = 80
    },
  ]
}

variable image {
  default = "gitlab/gitlab-ee:latest"
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

variable "gitlab_root_password" {}
variable "gitlab_runners_registration_token" {}
variable "auto_devops_domain" {}
variable "gitlab_external_url" {}
variable "mattermost_external_url" {}
variable "registry_external_url" {}
