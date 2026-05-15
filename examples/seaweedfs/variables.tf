variable "name" {
  default     = "seaweedfs"
  description = "Name prefix for all SeaweedFS resources."
}

variable "namespace" {
  default     = "seaweedfs-example"
  description = "Kubernetes namespace for SeaweedFS."
}

variable "image" {
  default     = "chrislusf/seaweedfs:latest"
  description = "Docker image for all SeaweedFS components."
}

# ── Ports ────────────────────────────────────────────────────────────────────

variable "ports" {
  type = object({
    master_grpc = number
    master_http = number
    volume_http = number
    filer_http  = number
    s3          = number
  })
  default = {
    master_grpc = 9333
    master_http = 9333
    volume_http = 8080
    filer_http  = 8888
    s3          = 8333
  }
  description = "Port assignments for each SeaweedFS component."
}

variable "metrics_port" {
  type = object({
    master_grpc = number
    volume_http = number
    filer_http  = number
    s3          = number
  })
  default = {
    master_grpc = 9324
    volume_http = 9325
    filer_http  = 9326
    s3          = 9327
  }
  description = "Metrics ports for each SeaweedFS component."
}

# ── S3 Credentials ───────────────────────────────────────────────────────────

variable "s3_access_key" {
  default     = "seaweedfs"
  description = "S3-compatible access key for the object store."
}

variable "s3_secret_key" {
  default     = "seaweedfs123"
  description = "S3-compatible secret key for the object store."
}

# ── Volume Server ────────────────────────────────────────────────────────────

variable "volume_max_file_system_usage" {
  default     = "0"
  description = "Max file system usage for volume server (0 = unlimited)."
}

variable "volume_storage_size" {
  default     = "10Gi"
  description = "Persistent volume size for the volume server data directory."
}

variable "volume_storage_class" {
  default     = null
  description = "Storage class for the volume server PVC. Null uses the default."
}

# ── Resource Limits ──────────────────────────────────────────────────────────

variable "resources_master" {
  default = {
    requests = { cpu = "100m", memory = "100Mi" }
    limits   = { memory = "200Mi" }
  }
  description = "Resource requests and limits for the master component."
}

variable "resources_volume" {
  default = {
    requests = { cpu = "100m", memory = "500Mi" }
    limits   = { memory = "1Gi" }
  }
  description = "Resource requests and limits for the volume component."
}

variable "resources_filer" {
  default = {
    requests = { cpu = "100m", memory = "200Mi" }
    limits   = { memory = "500Mi" }
  }
  description = "Resource requests and limits for the filer component."
}

variable "resources_s3" {
  default = {
    requests = { cpu = "100m", memory = "200Mi" }
    limits   = { memory = "500Mi" }
  }
  description = "Resource requests and limits for the S3 gateway component."
}
