variable "name" {
  default = "airflow"
}

variable "namespace" {
  default = "airflow-example"
}

variable "replicas" {
  default = 1
}

variable "storage_class_name" {
  default = "cephfs"
}