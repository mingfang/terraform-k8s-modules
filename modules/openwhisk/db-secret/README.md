
# Module `openwhisk/db-secret`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"openwhisk-db.auth"`)
* `namespace` (required)

## Output Values
* `name`

## Child Modules
* `secret` from [../../kubernetes/secret](../../kubernetes/secret)

