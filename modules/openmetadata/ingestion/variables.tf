variable "name" {
  default = "ingestion"
}

variable "namespace" {}

variable "image" {
  default = "openmetadata/ingestion:0.12.1"
}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name = "tcp"
      port = 8080
    },
  ]
}

variable "command" {
  default = ["/opt/airflow/ingestion_dependency.sh"]
}
variable "args" {
  default = []
}

variable "env" {
  default = []
}
variable "env_map" {
  default = {}
}
variable "env_file" {
  default = null
}
variable "env_from" {
  default = []
}

variable "annotations" {
  default = {}
}

variable "node_selector" {
  default = {}
}

variable "resources" {
  default = {
    requests = {
      cpu    = "250m"
      memory = "64Mi"
    }
  }
}

variable "service_account_name" {
  default = null
}

variable "overrides" {
  default = {}
}

variable "configmap" {
  default = null
}

variable "pvc" {
  default = null
}

variable "mount_path" {
  default     = "/opt/airflow/dags"
  description = "pvc mount path"
}

