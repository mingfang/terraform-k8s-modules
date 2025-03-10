
# Module `ingress-nginx`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"ingress-nginx"`)
* `namespace` (default `"ingress-nginx-example"`)
* `replicas` (default `1`)

## Output Values
* `ingress_class`

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`

## Child Modules
* `ingress` from [../../modules/kubernetes/ingress-nginx](../../modules/kubernetes/ingress-nginx)

