variable "name" {}

variable "namespace" {
  default = ""
}

variable "annotations" {
  type    = "map"
  default = {}
}

variable "gitlab_root_password" {}
variable "gitlab_runners_registration_token" {}
variable "auto_devops_domain" {}
variable "gitlab_external_url" {}
variable "mattermost_external_url" {}
variable "registry_external_url" {}

variable "storage_class_name" {}
variable "storage" {}

variable "gitlab_runner_replicas" {
  default = 1
}

module "gitlab" {
  source      = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/gitlab"
  name        = "${var.name}"
  namespace   = "${var.namespace}"
  annotations = "${var.annotations}"

  gitlab_root_password              = "${var.gitlab_root_password}"
  gitlab_runners_registration_token = "${var.gitlab_runners_registration_token}"
  auto_devops_domain                = "${var.auto_devops_domain}"
  gitlab_external_url               = "${var.gitlab_external_url}"
  mattermost_external_url           = "${var.mattermost_external_url}"
  registry_external_url             = "${var.registry_external_url}"

  storage_class_name = "${var.storage_class_name}"
  storage            = "${var.storage}"
}

module "gitlab-runner" {
  source    = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/gitlab-runner"
  name      = "${var.name}-runner"
  namespace = "${var.namespace}"
  replicas  = "${var.gitlab_runner_replicas}"

  registration_token = "${module.gitlab.gitlab_runners_registration_token}"
  gitlab_url         = "${module.gitlab.gitlab_external_url}"
}

output "gitlab_name" {
  value = "${module.gitlab.name}"
}

output "gitlab_port" {
  value = "${module.gitlab.port}"
}

output "gitlab_external_url" {
  value = "${var.gitlab_external_url}"
}

output "mattermost_external_url" {
  value = "${var.mattermost_external_url}"
}
