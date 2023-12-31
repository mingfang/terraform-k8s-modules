
# Module `kestra`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"kestra"`)
* `namespace` (default `"kestra-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_core_v1_persistent_volume_claim.data` from `k8s`
* `k8s_core_v1_persistent_volume_claim.kestra-wd` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.this` from `k8s`

## Child Modules
* `kestra` from [../../modules/kestra](../../modules/kestra)
* `postgres` from [../../modules/postgres](../../modules/postgres)

