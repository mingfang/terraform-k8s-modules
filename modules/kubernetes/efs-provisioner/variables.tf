variable "name" {
  default = "efs-provisioner"
}

variable "namespace" {
  default = "kube-system"
}

variable "image" {
  default = "quay.io/external_storage/efs-provisioner:latest"
}

variable "overrides" {
  default = {}
}

variable "FILE_SYSTEM_ID" {
  default     = null
  description = "set if using standard DNS name, e.g. *file-system-id*.efs.*aws-region*.amazonaws.com"
}

variable "AWS_REGION" {
  default     = null
  description = "set if using standard DNS name, e.g. *file-system-id*.efs.*aws-region*.amazonaws.com"
}

variable "DNS_NAME" {
  default     = null
  description = "set if using custom DNS name"
}

variable PROVISIONER_NAME {
  default = "amazon.com/aws-efs"
}
