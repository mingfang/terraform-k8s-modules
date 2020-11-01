variable "name" {}

variable "namespace" {}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name = "tcp"
      port = 8091
    },
  ]
}

variable "image" {
  default = "apache/druid:0.20.0"
}

variable "env" {
  default = []
}

variable "annotations" {
  default = {}
}

variable "resources" {
  default = {
    requests = {
      cpu    = "500m"
      memory = "128Mi"
    }
  }
}

variable "storage" {}

variable "storage_class" {}

variable "volume_claim_template_name" {
  default = "pvc"
}

variable "overrides" {
  default = {}
}

variable "druid_zk_service_host" {}

variable "druid_metadata_storage_type" {
  default = "derby"
  description = "The type of metadata storage to use. Choose from \"mysql\", \"postgresql\", or \"derby\"."
}

variable "druid_metadata_storage_connector_connectURI" {
  default = null
  description = "The JDBC URI for the database to connect to"
}

variable "druid_metadata_storage_connector_user" {
  default = null
  description = "The username to connect with."
}

variable "druid_metadata_storage_connector_password" {
  default = null
  description = "The Password Provider or String password used to connect with."
}

variable "druid_extensions_loadList" {
  default = []
  description = "A JSON array of extensions to load from extension directories by Druid. If it is not specified, its value will be null and Druid will load all the extensions under druid.extensions.directory. If its value is empty list [], then no extensions will be loaded at all. It is also allowed to specify absolute path of other custom extensions not stored in the common extensions directory."
}
