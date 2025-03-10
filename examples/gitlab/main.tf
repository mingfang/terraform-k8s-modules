variable name {
  default = "gitlab"
}

variable "namespace" {
  default = "gitlab-example"
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

resource "k8s_core_v1_namespace" "this" {
  metadata {
    labels = {
      "istio-injection" = "disabled"
    }

    name = var.namespace
  }
}

module "nfs-server" {
  source    = "../../modules/nfs-server-empty-dir"
  name      = "nfs-server"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}

module "storage" {
  source        = "../../modules/kubernetes/storage-nfs"
  name          = var.name
  namespace     = k8s_core_v1_namespace.this.metadata[0].name
  replicas      = 1
  mount_options = module.nfs-server.mount_options
  nfs_server    = module.nfs-server.service.spec[0].cluster_ip
  storage       = "1Gi"

  annotations = {
    "nfs-server-uid" = "${module.nfs-server.deployment.metadata[0].uid}"
  }
}

module "gitlab" {
  source             = "../../solutions/gitlab"
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
