
# Module `openldap`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"openldap"`)
* `namespace` (default `"openldap-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_core_v1_persistent_volume_claim.data` from `k8s`

## Child Modules
* `openldap` from [../../modules/openldap](../../modules/openldap)

