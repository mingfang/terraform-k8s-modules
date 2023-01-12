
# Module `kubernetes/job`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `annotations` (default `{}`)
* `backoff_limit` (default `4`)
* `command` (required)
* `configmap` (default `null`)
* `env` (default `[]`)
* `env_file` (default `null`)
* `env_from` (default `[]`)
* `env_map` (default `{}`)
* `image` (required)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `restart_policy` (default `"OnFailure"`)
* `secret` (default `null`)
* `volume_mounts` (default `[]`)
* `volumes` (default `[]`)

## Child Modules
* `job` from [../../../archetypes/job](../../../archetypes/job)

