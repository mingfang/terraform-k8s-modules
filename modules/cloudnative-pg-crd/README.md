
# Module `cloudnative-pg-crd`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)
* **null ([hashicorp/null](https://registry.terraform.io/providers/hashicorp/null/latest))** (any version)

## Input Variables
* `name` (default `"cloudnative-pg"`): Release name for the CloudNativePG operator. Used for label identification.
* `operator_version` (default `"1.29.1"`): CloudNativePG operator version to install. The corresponding YAML manifest must exist at `cnpg-<version>.yaml` in the module directory.

## Output Values
* `name`

## Managed Resources
* `null_resource.operator` from `null`
