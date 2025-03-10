
# Module `dremio`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"dremio"`)
* `namespace` (default `"dremio-example"`)
* `storage_class_name` (default `"cephfs"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_core_v1_persistent_volume_claim.this` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.this` from `k8s`

## Child Modules
* `config` from [../../modules/dremio/config](../../modules/dremio/config)
* `executor` from [../../modules/dremio/executor](../../modules/dremio/executor)
* `master-cordinator` from [../../modules/dremio/master-cordinator](../../modules/dremio/master-cordinator)
* `zookeeper` from [../../modules/zookeeper](../../modules/zookeeper)

