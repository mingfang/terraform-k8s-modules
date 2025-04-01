module "namespace" {
  source    = "../namespace"
  name      = var.namespace
  is_create = var.is_create_namespace
}

module "redis" {
  source    = "../../modules/generic-deployment-service"
  name      = "redis"
  namespace = module.namespace.name
  image     = "redis"
  ports     = [{ name = "tcp", port = 6379 }]
}

