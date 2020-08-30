module "config" {
  source    = "../../kubernetes/config-map"
  name      = var.name
  namespace = var.namespace

  from-map = {
    "db_host"              = var.db_host
    "db_host_port"         = "${var.db_host}:${var.db_port}"
    "db_port"              = var.db_port
    "db_prefix"            = "test_"
    "db_protocol"          = "http"
    "db_provider"          = "CouchDB"
    "db_url"               = "http://${var.db_host}:${var.db_port}"
    "db_whisk_actions"     = "test_whisks"
    "db_whisk_activations" = "test_activations"
    "db_whisk_auths"       = "test_subjects"
  }
}