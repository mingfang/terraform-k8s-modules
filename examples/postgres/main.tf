module "namespace" {
  source    = "../namespace"
  name      = var.namespace
  is_create = var.is_create_namespace
}

module "postgres" {
  source    = "../../modules/generic-statefulset-service"
  name      = "postgres"
  namespace = module.namespace.name
  image     = "postgres:17"
  ports     = [{ name = "tcp", port = 5432 }]
  storage   = "1Gi"

  env_map = {
    POSTGRES_DB       = "postgres"
    POSTGRES_USER     = "postgres"
    POSTGRES_PASSWORD = "postgres"
  }
}