variable "name" {}

variable "namespace" {}

variable "image" {
  default = "apache/airflow:1.10.10-python3.6"
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

variable "pvc_dags" {
  default = null
}

variable "pvc_logs" {
  default = null
}

variable "AIRFLOW__CORE__SQL_ALCHEMY_CONN" {}