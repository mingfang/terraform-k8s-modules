
# Module `minio`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `AWS_ACCESS_KEY_ID` (required)
* `AWS_SECRET_ACCESS_KEY` (required)
* `minio_access_key` (required)
* `minio_secret_key` (required)
* `name` (default `"minio"`)
* `namespace` (default `"minio-example"`)

## Output Values
* `minio_access_key`
* `minio_secret_key`

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.s3-gateway` from `k8s`

## Child Modules
* `job` from [../../modules/kubernetes/job](../../modules/kubernetes/job)
* `policies` from [../../modules/kubernetes/config-map](../../modules/kubernetes/config-map)
* `s3-gateway` from [../../modules/minio](../../modules/minio)

