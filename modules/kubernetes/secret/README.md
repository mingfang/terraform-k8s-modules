
# Module `kubernetes/secret`

Provider Requirements:
* **k8s (`mingfang/k8s`):** (any version)

## Input Variables
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

## Managed Resources
* `k8s_core_v1_secret.this` from `k8s`

