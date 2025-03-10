
# Module `taskcluster`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"taskcluster"`)
* `namespace` (default `"taskcluster-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.management` from `k8s`

## Child Modules
* `minio` from [../../modules/minio](../../modules/minio)
* `postgres` from [../../modules/postgres](../../modules/postgres)
* `rabbitmq` from [../../modules/rabbitmq](../../modules/rabbitmq)

