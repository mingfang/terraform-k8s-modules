
# Module `apitable`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"apitable"`)
* `namespace` (default `"apitable-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`

## Child Modules
* `init_db` from [../../modules/kubernetes/job](../../modules/kubernetes/job)
* `init_db_data` from [../../modules/kubernetes/job](../../modules/kubernetes/job)
* `minio` from [../../modules/minio](../../modules/minio)
* `mysql` from [../../modules/mysql](../../modules/mysql)
* `rabbitmq` from [../../modules/rabbitmq](../../modules/rabbitmq)
* `redis` from [../../modules/redis](../../modules/redis)

