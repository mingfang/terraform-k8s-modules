
# Module `pravega`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `minio_access_key` (default `""YOUR_ACCESS_KEY""`)
* `minio_secret_key` (default `""YOUR_SECRET_KEY""`)
* `name` (default `"pravega"`)
* `namespace` (default `"pravega-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_networking_k8s_io_v1_ingress.minio` from `k8s`
* `k8s_networking_k8s_io_v1_ingress.pravega` from `k8s`

## Child Modules
* `bookkeeper` from [../../modules/pravega/bookkeeper](../../modules/pravega/bookkeeper)
* `controller` from [../../modules/pravega/controller](../../modules/pravega/controller)
* `minio` from [../../modules/minio](../../modules/minio)
* `segmentstore` from [../../modules/pravega/segmentstore](../../modules/pravega/segmentstore)
* `zookeeper` from [../../modules/zookeeper](../../modules/zookeeper)

