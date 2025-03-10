
# Module `template-example`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"{{name}}"`)
* `namespace` (default `"{{namespace}}"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`

## Problems

## Error: Argument or block definition required

(at `template-example/main.tf` line 7)

An argument or block definition is required here.

