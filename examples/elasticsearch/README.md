
# Module `elasticsearch`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"elasticsearch"`)
* `namespace` (default `"elasticsearch-example"`)
* `replicas` (default `3`)
* `storage_class_name` (default `"cephfs"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.elasticsearch` from `k8s`

## Child Modules
* `elasticsearch` from [../../modules/elasticsearch](../../modules/elasticsearch)

