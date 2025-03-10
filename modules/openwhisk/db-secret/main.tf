module "secret" {
  source    = "../../kubernetes/secret"
  name      = var.name
  namespace = var.namespace

  from-map = {
    "db_password" = "c29tZV9wYXNzdzByZA=="
    "db_username" = "d2hpc2tfYWRtaW4="
  }
}