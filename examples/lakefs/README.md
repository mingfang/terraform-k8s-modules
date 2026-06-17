
# Module `lakefs`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `minio_access_key` (default "" (set via .auto.tfvars or env)
* `minio_secret_key` (default "" (set via .auto.tfvars or env)
* `name` (default `"lakefs"`)
* `namespace` (default `"lakefs-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_networking_k8s_io_v1_ingress.lakefs` from `k8s`
* `k8s_networking_k8s_io_v1_ingress.minio` from `k8s`

## Child Modules
* `lakefs` from [../../modules/lakefs](../../modules/lakefs)
* `minio` from [../../modules/minio](../../modules/minio)
* `postgres` from [../../modules/postgres](../../modules/postgres)

