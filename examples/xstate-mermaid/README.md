
# Module `xstate-mermaid`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"xstate-mermaid"`)
* `namespace` (default `"xstate-mermaid"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_networking_k8s_io_v1_ingress.xstate-mermaid` from `k8s`

## Child Modules
* `xstate-mermaid` from [../../modules/generic-deployment-service](../../modules/generic-deployment-service)

