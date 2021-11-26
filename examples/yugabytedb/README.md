
# Module `yugabytedb`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"yugabytedb"`)
* `namespace` (default `"yugabytedb-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_extensions_v1beta1_ingress.janusgraph` from `k8s`
* `k8s_extensions_v1beta1_ingress.master` from `k8s`

## Child Modules
* `janusgraph` from [../../modules/janusgraph](../../modules/janusgraph)
* `master` from [../../modules/yugabytedb/master](../../modules/yugabytedb/master)
* `master-storage` from [../../modules/kubernetes/storage-nfs](../../modules/kubernetes/storage-nfs)
* `nfs-server` from [../../modules/nfs-server-empty-dir](../../modules/nfs-server-empty-dir)
* `tserver` from [../../modules/yugabytedb/tserver](../../modules/yugabytedb/tserver)
* `tserver-storage` from [../../modules/kubernetes/storage-nfs](../../modules/kubernetes/storage-nfs)

