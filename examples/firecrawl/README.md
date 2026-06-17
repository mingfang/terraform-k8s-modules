
# Module `firecrawl`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `is_create_namespace` (default `true`)
* `name` (default `"firecrawl"`)
* `namespace` (default `"firecrawl-example"`)

## Managed Resources
* `k8s_networking_k8s_io_v1_ingress.api` from `k8s`

## Child Modules
* `api` from [../../modules/generic-deployment-service](../../modules/generic-deployment-service)
* `namespace` from [../namespace](../namespace)
* `nuq-postgres` from [../../modules/generic-statefulset-service](../../modules/generic-statefulset-service)
* `playwright-service` from [../../modules/generic-deployment-service](../../modules/generic-deployment-service)
* `redis` from [../../modules/generic-deployment-service](../../modules/generic-deployment-service)
* `worker` from [../../modules/generic-deployment-service](../../modules/generic-deployment-service)

