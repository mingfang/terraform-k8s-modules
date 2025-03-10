variable "name" {
  default = "openwhisk-db.config"
}
variable "namespace" {}

variable "db_host" {
  description = "openwhisk-couchdb.default.svc.cluster.local"
}
variable "db_port" {
  description = "5984"
}
