
# Module `etcd`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"etcd"`)
* `namespace` (default `"etcd-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`

## Child Modules
* `etcd` from [../../modules/etcd](../../modules/etcd)

