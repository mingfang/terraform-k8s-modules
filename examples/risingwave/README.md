
# Module `risingwave`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"risingwave"`)
* `namespace` (default `"risingwave-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.this` from `k8s`

## Child Modules
* `compactor-node` from [../../modules/risingwave](../../modules/risingwave)
* `compute-node` from [../../modules/risingwave](../../modules/risingwave)
* `etcd` from [../../modules/etcd](../../modules/etcd)
* `frontend` from [../../modules/risingwave](../../modules/risingwave)
* `meta-node` from [../../modules/risingwave](../../modules/risingwave)
* `minio` from [../../modules/minio](../../modules/minio)

