variable name {
  default = "gitlab-example"
}

variable "ingress_host" {
  default = "192.168.2.146"
}

variable "ingress_node_port_http" {
  default = 31000
}

//not used but set to avoid conflict
variable "ingress_node_port_https" {
  default = 31443
}

variable gitlab_root_password {
  default = "changeme"
}

variable gitlab_runners_registration_token {
  default = "wMFs1-9kpfMeKsfKsNFQ"
}

variable auto_devops_domain {
  default = "1.2.3.4.nip.io"
}

locals {
  mount_options = [
    "nfsvers=4.2",
    "proto=tcp",
    "port=2049",
  ]
}

module "nfs-server" {
  source = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/nfs-server-empty-dir"
  name   = "nfs-server"
}

module "storage" {
  source  = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/kubernetes/storage-nfs"
  name    = "${var.name}"
  count   = 1
  storage = "1Gi"

  annotations {
    "nfs-server-uid" = "${module.nfs-server.deployment_uid}"
  }

  nfs_server    = "${module.nfs-server.cluster_ip}"
  mount_options = "${local.mount_options}"
}

module "gitlab" {
  source             = "git::https://github.com/mingfang/terraform-provider-k8s.git//solutions/gitlab"
  name               = "${var.name}"
  storage_class_name = "${module.storage.storage_class_name}"
  storage            = "${module.storage.storage}"

  gitlab_root_password              = "${var.gitlab_root_password}"
  auto_devops_domain                = "${var.auto_devops_domain}"
  gitlab_runners_registration_token = "${var.gitlab_runners_registration_token}"
  gitlab_external_url               = "http://${k8s_extensions_v1beta1_ingress.this.spec[0].rules[0].host}:${var.ingress_node_port_http}"
  mattermost_external_url           = "http://${k8s_extensions_v1beta1_ingress.this.spec[0].rules.1.host}:${var.ingress_node_port_http}"
  registry_external_url             = "http://${k8s_extensions_v1beta1_ingress.this.spec[0].rules.2.host}:${var.ingress_node_port_http}"
}
