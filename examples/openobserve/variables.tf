variable "name" {
  default = "openobserve"
}

variable "namespace" {
  default = "openobserve-example"
}

variable "is_create_namespace" {
  default = true
}

variable "image" {
  default = "public.ecr.aws/zinclabs/openobserve:v0.92.2"
}

variable "root_user_email" {
  description = "OpenObserve root user email"
}

variable "root_user_password" {
  description = "OpenObserve root user password"
}

variable "root_user_token" {
  description = "Static ingestion token for the root user"
}

variable "storage" {
  default = "10Gi"
}

variable "minio_access_key" {
  description = "MinIO access key"
}

variable "minio_secret_key" {
  description = "MinIO secret key"
}

variable "minio_storage" {
  default = "5Gi"
}

variable "ai_base_url" {
  description = "OpenAI-compatible base URL for the AI assistant"
}

variable "ai_model" {
  description = "AI model identifier for the AI assistant"
}

variable "ai_api_key" {
  description = "API key for the AI model provider"
}
