
# Module `hugegraph`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `is_create_namespace` (default `true`)
* `name` (default `"hugegraph"`)
* `namespace` (default `"hugegraph-example"`)

## Managed Resources
* `k8s_networking_k8s_io_v1_ingress.hubble` from `k8s`
* `k8s_networking_k8s_io_v1_ingress.hugegraph` from `k8s`

## Child Modules
* `hubble` from [../../modules/generic-deployment-service](../../modules/generic-deployment-service)
* `hugegraph` from [../../modules/generic-deployment-service](../../modules/generic-deployment-service)
* `namespace` from [../namespace](../namespace)

