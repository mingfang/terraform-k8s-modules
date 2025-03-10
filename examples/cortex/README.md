
# Module `cortex`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"cortex"`)
* `namespace` (default `"cortex-example"`)
* `storage_class_name` (default `"cephfs"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.cortex` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.cortex-push` from `k8s`

## Child Modules
* `agent` from [../../modules/cortex/agent](../../modules/cortex/agent)
* `cassandra` from [../../modules/cassandra](../../modules/cassandra)
* `cortex` from [../../modules/cortex/cortex](../../modules/cortex/cortex)

