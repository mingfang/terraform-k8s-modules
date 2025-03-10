
# Module `cephfs`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `annotations` (default `{}`)
* `name` (required)
* `namespace` (required)
* `replicas` (default `1`)

## Output Values
* `pvcs`
* `storage_class`

## Managed Resources
* `k8s_core_v1_persistent_volume.this` from `k8s`
* `k8s_core_v1_persistent_volume_claim.this` from `k8s`
* `k8s_core_v1_secret.this` from `k8s`

