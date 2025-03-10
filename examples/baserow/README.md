
# Module `baserow`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"baserow"`)
* `namespace` (default `"baserow-example"`)
* `storage_class_name` (default `"cephfs"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_core_v1_persistent_volume_claim.media` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.baserow` from `k8s`

## Child Modules
* `backend` from [../../modules/baserow/backend](../../modules/baserow/backend)
* `media` from [../../modules/baserow/media](../../modules/baserow/media)
* `postgres` from [../../modules/postgres](../../modules/postgres)
* `redis` from [../../modules/redis](../../modules/redis)
* `web-frontend` from [../../modules/baserow/web-frontend](../../modules/baserow/web-frontend)

