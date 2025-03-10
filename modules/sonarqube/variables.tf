variable "name" {}

variable "namespace" {}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name = "http"
      port = 9000
    },
  ]
}

variable "image" {
  default = "sonarqube:9.2.4-community"
}

variable "env" {
  default = []
}

variable "annotations" {
  default = {}
}

variable "overrides" {
  default = {}
}

variable "sonarqube_data_pvc_name" {}

variable "sonarqube_extensions_pvc_name" {}

variable "sonarqube_logs_pvc_name" {}

variable "SONAR_JDBC_URL" {}

variable "SONAR_JDBC_USERNAME" {}

variable "SONAR_JDBC_PASSWORD" {}