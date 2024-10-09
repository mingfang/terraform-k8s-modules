
# Module `airbyte`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `minio_access_key` (default `"IUWU60H2527LP7DOYJVP"`)
* `minio_secret_key` (default `"bbdGponYV5p9P99EsasLSu4K3SjYBEcBLtyz7wbm"`)
* `name` (default `"airbyte"`)
* `namespace` (default `"airbyte-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_core_v1_persistent_volume_claim.config` from `k8s`
* `k8s_networking_k8s_io_v1_ingress.webapp` from `k8s`

## Child Modules
* `airbyte-server` from [../../modules/generic-deployment-service](../../modules/generic-deployment-service)
* `airbyte-webapp` from [../../modules/airbyte/airbyte-webapp](../../modules/airbyte/airbyte-webapp)
* `airbyte-worker` from [../../modules/airbyte/airbyte-worker](../../modules/airbyte/airbyte-worker)
* `minio` from [../../modules/minio](../../modules/minio)
* `postgres` from [../../modules/postgres](../../modules/postgres)

