variable "name" {
  default = "hindsight"
}

variable "namespace" {
  default = "hindsight-example"
}

variable "is_create_namespace" {
  default = true
}

variable "postgres_password" {
  type = string
}

variable "postgres_user" {
  type = string
}

variable "hindsight_llm_api_key" {
  type = string
}

variable "hindsight_llm_base_url" {
  type = string
}

variable "hindsight_litellm_api_key" {
  type = string
}

variable "hindsight_litellm_api_base" {
  type = string
}

variable "otel_exporter_endpoint" {
  type = string
}

variable "otel_exporter_headers" {
  type = string
}

variable "s3_access_key_id" {
  type = string
}

variable "s3_secret_access_key" {
  type = string
}

variable "s3_bucket" {
  type = string
}
