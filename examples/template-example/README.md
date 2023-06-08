
# Module `template-example`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"{{name}}"`)
* `namespace` (default `"{{name}}-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.this` from `k8s`

## Child Modules
* `{{name}}` from [../../modules/{{name}}](../../modules/{{name}})

## Problems

## Error: Invalid attribute name

(at `template-example/main.tf` line 29)

An attribute name is required after a dot.

## Error: Invalid attribute name

(at `template-example/main.tf` line 30)

An attribute name is required after a dot.

