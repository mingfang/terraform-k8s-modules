
# Module `budibase`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `minio_access_key` (default `"IUWU60H2527LP7DOYJVP"`)
* `minio_secret_key` (default `"bbdGponYV5p9P99EsasLSu4K3SjYBEcBLtyz7wbm"`)
* `name` (default `"budibase"`)
* `namespace` (default `"budibase-example"`)
* `storage_class_name` (default `"cephfs"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_extensions_v1beta1_ingress.proxy` from `k8s`

## Child Modules
* `budibase-apps` from [../../modules/budibase/budibase-apps](../../modules/budibase/budibase-apps)
* `budibase-worker` from [../../modules/budibase/budibase-worker](../../modules/budibase/budibase-worker)
* `couchdb` from [../../modules/couchdb](../../modules/couchdb)
* `minio` from [../../modules/minio](../../modules/minio)
* `nginx` from [../../modules/nginx](../../modules/nginx)
* `redis` from [../../modules/redis](../../modules/redis)
* `secret` from [../../modules/kubernetes/secret](../../modules/kubernetes/secret)

