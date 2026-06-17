
# Module `affine`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `is_create_namespace` (default `true`)
* `name` (default `"affine"`)
* `namespace` (default `"affine-example"`)

## Managed Resources
* `k8s_networking_k8s_io_v1_ingress.affine` from `k8s`

## Child Modules
* `affine` from [../../modules/generic-deployment-service](../../modules/generic-deployment-service)
* `namespace` from [../namespace](../namespace)
* `postgres` from [../../modules/generic-statefulset-service](../../modules/generic-statefulset-service)
* `redis` from [../../modules/generic-deployment-service](../../modules/generic-deployment-service)

