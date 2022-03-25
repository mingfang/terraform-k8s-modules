module "init-job" {
  source    = "../kubernetes/job"
  name      = "init-job"
  namespace = var.namespace

  image = "curlimages/curl"
  command = [
    "sh",
    "-c",
    <<-EOF
    sleep 30
    curl -u $${COUCHDB_USER}:$${COUCHDB_PASSWORD} -X PUT ${var.name}:${var.ports[0].port}/_users
    curl -u $${COUCHDB_USER}:$${COUCHDB_PASSWORD} -X PUT ${var.name}:${var.ports[0].port}/_replicator
    curl -u $${COUCHDB_USER}:$${COUCHDB_PASSWORD} -X PUT ${var.name}:${var.ports[0].port}/_global_changes
    EOF
  ]

  env = concat([
    {
      name = "COUCHDB_USER"
      value_from = {
        secret_key_ref = {
          key  = var.db_username_key
          name = var.db_secret_name
        }
      }
    },
    {
      name = "COUCHDB_PASSWORD"
      value_from = {
        secret_key_ref = {
          key  = var.db_password_key
          name = var.db_secret_name
        }
      }
    },
  ], var.env)
}
