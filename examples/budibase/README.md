
# Module `budibase`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `minio_access_key` (default `""YOUR_ACCESS_KEY""`)
* `minio_secret_key` (default `""YOUR_SECRET_KEY""`)
* `name` (default `"budibase"`)
* `namespace` (default `"budibase-example"`)
* `storage_class_name` (default `"cephfs"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_networking_k8s_io_v1_ingress.proxy` from `k8s`

## Child Modules
* `budibase-apps` from [../../modules/budibase/budibase-apps](../../modules/budibase/budibase-apps)
* `budibase-worker` from [../../modules/budibase/budibase-worker](../../modules/budibase/budibase-worker)
* `couchdb` from [../../modules/couchdb](../../modules/couchdb)
* `minio` from [../../modules/minio](../../modules/minio)
* `nginx` from [../../modules/nginx](../../modules/nginx)
* `redis` from [../../modules/redis](../../modules/redis)
* `secret` from [../../modules/kubernetes/secret](../../modules/kubernetes/secret)

