variable "name" {}

variable "namespace" {}

variable "image" {
  default = "prefecthq/prefect:all_extras-0.12.5"
}

variable "replicas" {
  default = 1
}

variable "env" {
  default = []
}

variable "annotations" {
  default = {}
}

variable "resources" {
  default = {
    limits = {
      cpu = "100m"
      memory = "128Mi"
    }
  }
}

variable "overrides" {
  default = {}
}

variable "PREFECT__CLOUD__AGENT__AUTH_TOKEN" {
  default = ""
  description = "only needed for cloud"
}

variable "PREFECT__CLOUD__API" {
  description = "http://prefect-apollo:4200"
}

variable "NAMESPACE" {
  default = ""
}
variable "IMAGE_PULL_SECRETS" {
  default = ""
}
variable "PREFECT__CLOUD__AGENT__LABELS" {
  default = "[]"
}
variable "JOB_MEM_REQUEST" {
  default = ""
}
variable "JOB_MEM_LIMIT" {
  default = ""
}
variable "JOB_CPU_REQUEST" {
  default = ""
}
variable "JOB_CPU_LIMIT" {
  default = ""
}
variable "IMAGE_PULL_POLICY" {
  default = ""
}
variable "SERVICE_ACCOUNT_NAME" {
  default = ""
}
variable "PREFECT__BACKEND" {
  default = "server"
  description = "server or cloud"
}
variable "PREFECT__CLOUD__AGENT__AGENT_ADDRESS" {
  default = "http://:8080"
}

