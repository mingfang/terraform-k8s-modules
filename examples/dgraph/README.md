
# Module `dgraph`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"dgraph"`)
* `namespace` (default `"dgraph-example"`)
* `storage_class_name` (default `"cephfs"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.dgraph-alpha` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.dgraph-grpc` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.dgraph-nginx` from `k8s`

## Child Modules
* `dgraph-alpha` from [../../modules/dgraph/dgraph-alpha](../../modules/dgraph/dgraph-alpha)
* `dgraph-nginx` from [../../modules/nginx](../../modules/nginx)
* `dgraph-ratel` from [../../modules/dgraph/dgraph-ratel](../../modules/dgraph/dgraph-ratel)
* `dgraph-zero` from [../../modules/dgraph/dgraph-zero](../../modules/dgraph/dgraph-zero)

