
# Module `budibase`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `minio_access_key` (default `"IUWU60H2527LP7DOYJVP"`)
* `minio_secret_key` (default `"bbdGponYV5p9P99EsasLSu4K3SjYBEcBLtyz7wbm"`)
* `name` (default `"budibase"`)
* `namespace` (default `"budibase-example"`)
* `storage_class_name` (default `"cephfs-csi"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_networking_k8s_io_v1_ingress.proxy` from `k8s`

## Child Modules
* `budibase-apps` from [../../modules/generic-deployment-service](../../modules/generic-deployment-service)
* `budibase-proxy` from [../../modules/generic-deployment-service](../../modules/generic-deployment-service)
* `budibase-worker` from [../../modules/generic-deployment-service](../../modules/generic-deployment-service)
* `couchdb` from [../../modules/generic-statefulset-service](../../modules/generic-statefulset-service)
* `minio` from [../../modules/generic-statefulset-service](../../modules/generic-statefulset-service)
* `redis` from [../../modules/redis](../../modules/redis)

