
# Module `weave-scope/agent`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"docker.io/weaveworks/scope:1.13.1"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `resources` (default `{"limits":{"memory":"2Gi"},"requests":{"cpu":"100m","memory":"100Mi"}}`)
* `weave_scope_app_url` (required)

## Output Values
* `daemonset`
* `name`

## Child Modules
* `daemonset` from [../../../archetypes/daemonset](../../../archetypes/daemonset)

