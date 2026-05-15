output "name" {
  description = "Name prefix for all SeaweedFS resources."
  value       = var.name
}

output "namespace" {
  description = "Kubernetes namespace."
  value       = var.namespace
}

output "master_name" {
  description = "Name of the master deployment."
  value       = module.seaweedfs_master.name
}

output "master_grpc_port" {
  description = "Master gRPC port."
  value       = 9333
}

output "master_http_port" {
  description = "Master HTTP/admin port."
  value       = 9333
}

output "volume_name" {
  description = "Name of the volume deployment."
  value       = module.seaweedfs_volume.name
}

output "volume_http_port" {
  description = "Volume server HTTP port."
  value       = 8080
}

output "filer_name" {
  description = "Name of the filer deployment."
  value       = module.seaweedfs_filer.name
}

output "filer_http_port" {
  description = "Filer HTTP port."
  value       = 8888
}

output "s3_name" {
  description = "Name of the S3 gateway deployment."
  value       = module.seaweedfs_s3.name
}

output "s3_port" {
  description = "S3 gateway HTTP port."
  value       = 8333
}

output "s3_access_key" {
  description = "S3 access key."
  value       = var.s3_access_key
}

output "s3_secret_key" {
  description = "S3 secret key."
  value       = var.s3_secret_key
}

output "credentials_secret_name" {
  description = "Name of the Kubernetes secret containing S3 credentials."
  value       = k8s_core_v1_secret.s3_credentials.metadata[0].name
}

output "endpoint_url" {
  description = "Full S3-compatible endpoint URL."
  value       = "http://${module.seaweedfs_s3.name}.${var.namespace}.svc.cluster.local:8333"
}
