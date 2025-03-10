
# Module `zookeeper`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"zookeeper"`)
* `namespace` (default `"zookeeper-example"`)
* `replicas` (default `3`)
* `storage` (default `"1Gi"`)
* `storage_class` (default `null`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`

## Child Modules
* `zookeeper` from [../../modules/zookeeper](../../modules/zookeeper)

