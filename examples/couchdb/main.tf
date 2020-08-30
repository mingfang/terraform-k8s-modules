resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "secret" {
  source    = "../../modules/kubernetes/secret"
  name      = "couchdb"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  from-map = {
    "db_username" = base64encode("foo")
    "db_password" = base64encode("bar")
  }
}

module "couchdb" {
  source    = "../../modules/couchdb"
  name      = "couchdb"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  replicas      = var.replicas
  storage       = "1Gi"
  storage_class = var.storage_class_name

  db_secret_name  = module.secret.name
  db_username_key = "db_username"
  db_password_key = "db_password"
}