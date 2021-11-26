
# Module `couchdb`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"couchdb"`)
* `namespace` (default `"couchdb-example"`)
* `replicas` (default `1`)
* `storage_class_name` (default `"cephfs"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`

## Child Modules
* `couchdb` from [../../modules/couchdb](../../modules/couchdb)
* `secret` from [../../modules/kubernetes/secret](../../modules/kubernetes/secret)

