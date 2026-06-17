
# Module `localstack`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `is_create_namespace` (default `true`)
* `name` (default `"localstack"`)
* `namespace` (default `"localstack-example"`)

## Managed Resources
* `k8s_networking_k8s_io_v1_ingress.this` from `k8s`

## Child Modules
* `localstack` from [../../modules/generic-deployment-service](../../modules/generic-deployment-service)
* `namespace` from [../namespace](../namespace)

