
# Module `kubernetes/secret`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `annotations` (default `{}`)
* `from-dir` (default `null`)
* `from-file` (default `null`)
* `from-files` (default `[]`)
* `from-map` (default `{}`)
* `name` (required)
* `namespace` (required)
* `type` (default `"Opaque"`): Opaque or kubernetes.io/dockerconfigjson

## Output Values
* `checksum`
* `name`
* `secret`
* `secret_ref`

## Managed Resources
* `k8s_core_v1_secret.this` from `k8s`

