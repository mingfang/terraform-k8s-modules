
# Module `scylla`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"scylla"`)
* `namespace` (default `"scylla-example"`)
* `replicas` (default `3`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`

## Child Modules
* `nfs-server` from [../../modules/nfs-server-empty-dir](../../modules/nfs-server-empty-dir)
* `scylla` from [../../modules/scylla](../../modules/scylla)
* `scylla-storage` from [../../modules/kubernetes/storage-nfs](../../modules/kubernetes/storage-nfs)

