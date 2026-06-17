
# Module `template-deployment`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `annotations` (default `{}`)
* `args` (default `{}`)
* `command` (default `{}`)
* `env` (default `[]`)
* `env_file` (default `null`)
* `env_from` (default `[]`)
* `env_map` (default `{}`)
* `image` (default `"{{image}}"`)
* `image_pull_secrets` (default `[]`)
* `name` (default `"{{name}}"`)
* `namespace` (required)
* `node_selector` (default `{}`)
* `ports` (default `{}`)
* `replicas` (default `1`)
* `resources` (default `{"requests":{"cpu":"250m","memory":"64Mi"}}`)

## Output Values
* `deployment`
* `name`
* `ports`
* `service`

## Child Modules
* `deployment-service` from [../../archetypes/deployment-service](../../archetypes/deployment-service)

## Problems

## Error: Invalid expression

(at `template-deployment/main.tf` line 128)

Expected the start of an expression, but found an invalid expression token.

## Error: Missing key/value separator

(at `template-deployment/variables.tf` line 22)

Expected an equals sign ("=") to mark the beginning of the attribute value.

