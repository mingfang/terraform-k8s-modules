
# Module `template-generic-deployment-service`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `annotations` (default `{}`)
* `args` (default `{}`)
* `command` (default `{}`)
* `configmap` (default `null`)
* `configmap_mount_path` (default `"{{ configmap_mount_path }}"`)
* `env` (default `[]`)
* `env_file` (default `null`)
* `env_from` (default `[]`)
* `env_map` (default `{}`)
* `image` (default `"{{image}}"`)
* `image_pull_secrets` (default `[]`)
* `mount_path` (default `"/data"`): pvc mount path
* `name` (default `"{{name}}"`)
* `namespace` (required)
* `node_selector` (default `{}`)
* `overrides` (default `{}`)
* `ports` (default `{}`)
* `post_start_command` (default `{}`)
* `pvc` (default `null`)
* `replicas` (default `1`)
* `resources` (default `{"requests":{"cpu":"250m","memory":"64Mi"}}`)

## Output Values
* `deployment`
* `name`
* `ports`
* `service`

## Child Modules
* `deployment-service` from [../generic-deployment-service](../generic-deployment-service)

## Problems

## Error: Argument or block definition required

(at `template-generic-deployment-service/main.tf` line 24)

An argument or block definition is required here.

## Error: Missing key/value separator

(at `template-generic-deployment-service/variables.tf` line 22)

Expected an equals sign ("=") to mark the beginning of the attribute value.

