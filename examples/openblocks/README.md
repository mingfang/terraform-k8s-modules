
# Module `openblocks`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"openblocks"`)
* `namespace` (default `"openblocks-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_core_v1_persistent_volume_claim.data` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.this` from `k8s`

## Child Modules
* `api-service` from [../../modules/openblocks/api-service](../../modules/openblocks/api-service)
* `ferretdb` from [../../modules/ferretdb](../../modules/ferretdb)
* `frontend` from [../../modules/openblocks/frontend](../../modules/openblocks/frontend)
* `mongodb` from [../../modules/generic-deployment-service](../../modules/generic-deployment-service)
* `node-service` from [../../modules/openblocks/node-service](../../modules/openblocks/node-service)
* `redis` from [../../modules/generic-deployment-service](../../modules/generic-deployment-service)

