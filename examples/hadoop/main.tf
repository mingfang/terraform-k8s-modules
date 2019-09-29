variable "namespace" {
  default = "hadoop"
}

resource "k8s_core_v1_namespace" "this" {
  metadata {
    labels = {
      "istio-injection" = "disabled"
    }

    name = var.namespace
  }
}

module "master" {
  source = "../../modules/hadoop/master"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}

module "nodes" {
  source = "../../modules/hadoop/node"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  namenode = module.master.name
  resourcemanager = module.master.name
}