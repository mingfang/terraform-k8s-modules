
# Module `cloudbeaver`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"cloudbeaver"`)
* `namespace` (default `"cloudbeaver-example"`)
* `replicas` (default `1`)
* `storage_class_name` (default `"cephfs"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_core_v1_persistent_volume_claim.workspace` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.cloudbeaver` from `k8s`

## Child Modules
* `cloudbeaver` from [../../modules/cloudbeaver](../../modules/cloudbeaver)
* `postgres` from [../../modules/postgres](../../modules/postgres)

