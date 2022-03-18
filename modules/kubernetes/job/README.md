
# Module `kubernetes/job`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `annotations` (default `{}`)
* `backoff_limit` (default `4`)
* `command` (required)
* `env` (default `[]`)
* `image` (required)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `restart_policy` (default `"OnFailure"`)
* `volume_mounts` (default `null`)
* `volumes` (default `null`)

## Child Modules
* `job` from [../../../archetypes/job](../../../archetypes/job)

