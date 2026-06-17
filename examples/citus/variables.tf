variable "name" {
  default = "citus"
}

variable "namespace" {
  default = "citus-example"
}

variable "is_create_namespace" {
  default = true
}

variable "image" {
  default = "registry.rebelsoft.com/postgres-vectorchord:18-trixie"
}

variable "replicas" {
  default = 3
}

variable "args" {
  default = []
}

variable "shared_preload_libraries" {
  default = "citus, pg_search, vectorscale-0.9.0.so, pg_cron"
}

variable "search_path" {
  default = ""
}

variable "coordinator_storage" {
  default = "10Gi"
}

variable "coordinator_storage_class" {
  default = ""
}

variable "worker_storage" {
  default = "100Gi"
}

variable "worker_storage_class" {
  default = ""
}

variable "database" {
  default = "postgres"
}

variable "username" {
  default = "postgres"
}

variable "password" {
  default = "postgres"
}