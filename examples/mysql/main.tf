resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}



module "mysql" {
  source        = "../../modules/mysql"
  name          = "mysql"
  namespace     = k8s_core_v1_namespace.this.metadata[0].name
  storage_class = "cephfs"
  storage       = "1Gi"
  replicas      = 1

  MYSQL_USER          = "mysql"
  MYSQL_PASSWORD      = "mysql"
  MYSQL_ROOT_PASSWORD = "mysql"
  MYSQL_DATABASE      = "mysql"
}
