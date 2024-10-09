
# Module `countly/frontend`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `annotations` (default `{}`)
* `args` (default `[]`)
* `command` (default `[]`)
* `configmap` (default `null`)
* `configmap_mount_path` (default `"/config"`)
* `env` (default `[]`)
* `env_file` (default `null`)
* `env_from` (default `[]`)
* `env_map` (default `{}`)
* `image` (default `"countly/frontend:23.06.16"`)
* `image_pull_secrets` (default `[]`)
* `mount_path` (default `"/data"`): pvc mount path
* `name` (default `"countly-frontend"`)
* `namespace` (required)
* `node_selector` (default `{}`)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"tcp","port":6001}]`)
* `post_start_command` (default `[]`)
* `pvc` (default `null`)
* `replicas` (default `1`)
* `resources` (default `{"requests":{"cpu":"250m","memory":"64Mi"}}`)
* `service_account_name` (default `null`)

## Output Values
* `deployment`
* `name`
* `ports`
* `service`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)

