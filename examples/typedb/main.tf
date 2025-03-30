module "namespace" {
  source    = "../namespace"
  name      = var.namespace
  is_create = var.is_create_namespace
}

module "typedb" {
  source    = "../../modules/generic-statefulset-service"
  name      = "typedb"
  namespace = module.namespace.name
  image     = "typedb/typedb:latest"
  ports     = [{ name = "tcp", port = 1729 }]

  storage   = "1Gi"
  mount_path = "/opt/typedb-all-linux-x86_64/server/data"
}