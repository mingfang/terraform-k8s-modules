
# Module `querybook`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"querybook"`)
* `namespace` (default `"querybook-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.querybook` from `k8s`

## Child Modules
* `elasticsearch` from [../../modules/elasticsearch](../../modules/elasticsearch)
* `mysql` from [../../modules/mysql](../../modules/mysql)
* `querybook-scheduler` from [../../modules/querybook/querybook-scheduler](../../modules/querybook/querybook-scheduler)
* `querybook-web` from [../../modules/querybook/querybook-web](../../modules/querybook/querybook-web)
* `querybook-worker` from [../../modules/querybook/querybook-worker](../../modules/querybook/querybook-worker)
* `redis` from [../../modules/redis](../../modules/redis)

