
# Module `cassandra`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"cassandra"`)
* `namespace` (default `"cassandra-example"`)
* `replicas` (default `3`)
* `storage_class_name` (default `"cephfs"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`

## Child Modules
* `cassandra` from [../../modules/cassandra](../../modules/cassandra)

