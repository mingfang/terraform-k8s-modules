
# Module `druid`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `minio_access_key` (default `""YOUR_ACCESS_KEY""`)
* `minio_secret_key` (default `""YOUR_SECRET_KEY""`)
* `name` (default `"druid"`)
* `namespace` (default `"druid-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_networking_k8s_io_v1_ingress.minio` from `k8s`
* `k8s_networking_k8s_io_v1_ingress.router` from `k8s`

## Child Modules
* `broker` from [../../modules/druid/broker](../../modules/druid/broker)
* `coordinator` from [../../modules/druid/coordinator](../../modules/druid/coordinator)
* `historical` from [../../modules/druid/historical](../../modules/druid/historical)
* `middlemanager` from [../../modules/druid/middlemanager](../../modules/druid/middlemanager)
* `minio` from [../../modules/minio](../../modules/minio)
* `postgres` from [../../modules/postgres](../../modules/postgres)
* `router` from [../../modules/druid/router](../../modules/druid/router)
* `zookeeper` from [../../modules/zookeeper](../../modules/zookeeper)

