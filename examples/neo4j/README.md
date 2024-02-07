
# Module `neo4j`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"neo4j"`)
* `namespace` (default `"neo4j-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.this` from `k8s`

## Child Modules
* `neo4j` from [../../modules/neo4j](../../modules/neo4j)
* `neo4j-proxy` from [../../modules/neo4j/proxy](../../modules/neo4j/proxy)

