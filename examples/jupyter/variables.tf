variable "name" {
  default = "jupyter"
}

variable "namespace" {
  default = "jupyter-example"
}

variable "user_pvc_name" {
  default = "jupyter-users"
}

variable "user_storage" {
  default = "1Gi"
}
