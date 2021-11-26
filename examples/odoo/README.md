
# Module `odoo`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"odoo"`)
* `namespace` (default `"odoo-example"`)
* `replicas` (default `1`)
* `storage_class` (default `"cephfs"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_core_v1_persistent_volume_claim.data` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.odoo` from `k8s`

## Child Modules
* `odoo` from [../../modules/odoo](../../modules/odoo)
* `postgres` from [../../modules/postgres](../../modules/postgres)

