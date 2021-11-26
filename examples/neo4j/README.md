
# Module `neo4j`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"neo4j"`)
* `namespace` (default `"neo4j-example"`)
* `replicas` (default `3`)
* `storage_class_name` (default `"cephfs"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.bolt` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.core` from `k8s`

## Child Modules
* `core` from [../../modules/neo4j/core](../../modules/neo4j/core)

