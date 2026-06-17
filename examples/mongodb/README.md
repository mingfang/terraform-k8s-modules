
# Module `mongodb`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"mongodb"`)
* `namespace` (default `"mongodb-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_networking_k8s_io_v1_ingress.mongo-express` from `k8s`

## Child Modules
* `mongo-express` from [../../modules/generic-deployment-service](../../modules/generic-deployment-service)
* `mongodb` from [../../modules/generic-statefulset-service](../../modules/generic-statefulset-service)

