
# Module `kong`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `is_create_namespace` (default `true`)
* `name` (default `"kong"`)
* `namespace` (default `"kong-example"`)

## Managed Resources
* `k8s_networking_k8s_io_v1_ingress.admin` from `k8s`
* `k8s_networking_k8s_io_v1_ingress.kong` from `k8s`
* `k8s_networking_k8s_io_v1_ingress.ui` from `k8s`

## Child Modules
* `config` from [../../modules/kubernetes/config-map](../../modules/kubernetes/config-map)
* `deck` from [../../modules/kubernetes/job](../../modules/kubernetes/job)
* `kong` from [../../modules/generic-deployment-service](../../modules/generic-deployment-service)
* `namespace` from [../namespace](../namespace)
* `postgres` from [../../modules/generic-statefulset-service](../../modules/generic-statefulset-service)

