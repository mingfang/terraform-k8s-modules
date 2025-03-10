resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "pd" {
  source    = "../../modules/tidb/pd"
  name      = "pd"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  replicas      = 3
  storage       = "1Gi"
  storage_class = "cephfs"

}

module "tikv" {
  source    = "../../modules/tidb/tikv"
  name      = "tikv"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas      = 3
  storage       = "1Gi"
  storage_class = "cephfs"

  pd = module.pd.pd
}

module "tidb" {
  source    = "../../modules/tidb/tidb"
  name      = "tidb"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  pd = module.pd.pd
}
