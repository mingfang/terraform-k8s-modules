
# Module `janusgraph`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"janusgraph"`)
* `namespace` (default `"janusgraph-example"`)
* `replicas` (default `3`)

## Output Values
* `console`

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_extensions_v1beta1_ingress.this` from `k8s`

## Child Modules
* `elasticsearch` from [../../modules/elasticsearch](../../modules/elasticsearch)
* `elasticsearch_storage` from [../../modules/kubernetes/storage-nfs](../../modules/kubernetes/storage-nfs)
* `janusgraph` from [../../modules/janusgraph](../../modules/janusgraph)
* `nfs-server` from [../../modules/nfs-server-empty-dir](../../modules/nfs-server-empty-dir)
* `scylla` from [../../modules/scylla](../../modules/scylla)
* `scylla-storage` from [../../modules/kubernetes/storage-nfs](../../modules/kubernetes/storage-nfs)

