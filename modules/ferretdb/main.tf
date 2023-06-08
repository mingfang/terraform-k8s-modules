module "deployment-service" {
  source    = "../generic-deployment-service"
  name      = var.name
  namespace = var.namespace
  image     = var.image
  ports     = var.ports
  env_map   = var.env_map
}