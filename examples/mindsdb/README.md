
# Module `mindsdb`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `is_create_namespace` (default `true`)
* `name` (default `"mindsdb"`)
* `namespace` (default `"mindsdb-example"`)

## Managed Resources
* `k8s_core_v1_persistent_volume_claim.data` from `k8s`
* `k8s_networking_k8s_io_v1_ingress.this` from `k8s`

## Child Modules
* `mindsdb` from [../../modules/generic-deployment-service](../../modules/generic-deployment-service)
* `namespace` from [../namespace](../namespace)

