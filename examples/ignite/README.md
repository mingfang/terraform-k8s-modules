
# Module `ignite`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `is_create_namespace` (default `true`)
* `name` (default `"ignite"`)
* `namespace` (default `"ignite-example"`)
* `replicas` (default `3`)

## Managed Resources
* `k8s_networking_k8s_io_v1_ingress.this` from `k8s`

## Child Modules
* `ignite` from [../../modules/generic-statefulset-service](../../modules/generic-statefulset-service)
* `ignite_config` from [../../modules/kubernetes/config-map](../../modules/kubernetes/config-map)
* `ignite_init` from [../../modules/kubernetes/job](../../modules/kubernetes/job)
* `namespace` from [../namespace](../namespace)

