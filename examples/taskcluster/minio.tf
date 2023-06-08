module "minio" {
  source    = "../../modules/minio"
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  replicas           = 4
  storage            = "1Gi"
  storage_class_name = "cephfs"

  minio_access_key = "minio"
  minio_secret_key = "minio1234"

  create_buckets = ["taskcluster"]
}


