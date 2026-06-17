variable "name" {
  default = "alluxio"
}

variable "namespace" {
  default = "alluxio-example"
}

variable "minio_access_key" {
  description = "MinIO access key for S3 endpoint"
  default     = ""
}

variable "minio_secret_key" {
  description = "MinIO secret key for S3 endpoint"
  default     = ""
}