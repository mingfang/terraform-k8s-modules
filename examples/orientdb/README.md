
# Module `orientdb`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"orientdb"`)
* `namespace` (default `"orientdb-example"`)
* `replicas` (default `3`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_extensions_v1beta1_ingress.this` from `k8s`

## Child Modules
* `nfs-server` from [../../modules/nfs-server-empty-dir](../../modules/nfs-server-empty-dir)
* `orientdb` from [../../modules/orientdb](../../modules/orientdb)
* `orientdb_storage` from [../../modules/kubernetes/storage-nfs](../../modules/kubernetes/storage-nfs)

