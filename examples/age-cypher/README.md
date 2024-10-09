
# Module `age-cypher`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"age-cypher"`)
* `namespace` (default `"age-cypher"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_networking_k8s_io_v1_ingress.age-cypher` from `k8s`
* `k8s_networking_k8s_io_v1_ingress.age-playground` from `k8s`

## Child Modules
* `age-cypher` from [../../modules/generic-deployment-service](../../modules/generic-deployment-service)

