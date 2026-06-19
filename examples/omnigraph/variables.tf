variable "name" {
  description = "Name of the omnigraph deployment"
  default     = "omnigraph"
}

variable "namespace" {
  description = "Kubernetes namespace"
  default     = "omnigraph-example"
}

variable "is_create_namespace" {
  description = "Whether to create the namespace"
  default     = true
}

variable "image" {
  # Requires omnigraph >= 0.7.1: the resilient-boot behavior this example relies
  # on (a partially-applied/quarantined graph no longer refuses server boot)
  # landed in 0.7.1. Pin a tag >= 0.7.1 in production rather than `:latest`.
  description = "Omnigraph server container image (>= 0.7.1)"
  default     = "registry.rebelsoft.com/omnigraph:latest"
}

variable "bearer_token" {
  description = "Bearer token for Omnigraph server authentication"
  default     = "change-me"
}

variable "s3_bucket" {
  description = "S3 bucket name for Omnigraph graph storage"
  default     = "omnigraph-local"
}

variable "graph_name" {
  description = "Graph name within the S3 bucket"
  default     = "example"
}

variable "rustfs_storage_access" {
  description = "RustFS storage access identifier"
  default     = "omnigraph"
}

variable "rustfs_storage_secret" {
  description = "RustFS storage secret key"
  default     = "omnigraph"
}

variable "rustfs_storage" {
  description = "RustFS persistent volume size"
  default     = "10Gi"
}

variable "aws_region" {
  description = "AWS region for S3 access"
  default     = "us-east-1"
}

variable "config_git_repo" {
  description = "Git repository URL containing schema and graph config files"
  default     = "https://github.com/example/omnigraph-configs.git"
}

variable "config_git_branch" {
  description = "Git branch to checkout"
  default     = "main"
}

variable "config_git_poll_interval" {
  description = "Git polling interval in seconds (0 = disabled sidecar)"
  type        = number
  default     = 60
}

variable "git_auth_token" {
  description = "Git authentication token (required for private repos)"
  default     = ""
}
