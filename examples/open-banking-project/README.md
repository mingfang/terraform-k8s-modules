
# Module `open-banking-project`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"obp"`)
* `namespace` (default `"obp-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_extensions_v1beta1_ingress.open-banking-project-api` from `k8s`

## Child Modules
* `kafka` from [../../modules/kafka](../../modules/kafka)
* `kafka_storage` from [../../modules/kubernetes/storage-nfs](../../modules/kubernetes/storage-nfs)
* `nfs-server` from [../../modules/nfs-server-empty-dir](../../modules/nfs-server-empty-dir)
* `open-banking-project-api` from [../../modules/open-banking-project](../../modules/open-banking-project)
* `postgres` from [../../modules/postgres](../../modules/postgres)
* `postgres-storage` from [../../modules/kubernetes/storage-nfs](../../modules/kubernetes/storage-nfs)
* `zookeeper` from [../../modules/zookeeper](../../modules/zookeeper)
* `zookeeper_storage` from [../../modules/kubernetes/storage-nfs](../../modules/kubernetes/storage-nfs)

