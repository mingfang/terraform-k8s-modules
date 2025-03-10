resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "secret" {
  source    = "../../modules/kubernetes/secret"
  name      = "secret"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  from-map = {
    password = base64encode("postgres")
  }
}

module "coordinator" {
  source    = "../../modules/citus/coordinator"
  name      = "coordinator"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  storage       = "1Gi"
  storage_class = "cephfs"

  secret = module.secret.name
}


module "worker" {
  source    = "../../modules/citus/worker"
  name      = "worker"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  replicas      = 3
  storage       = "1Gi"
  storage_class = "cephfs"

  coordinator = module.coordinator.name
  secret      = module.secret.name
}