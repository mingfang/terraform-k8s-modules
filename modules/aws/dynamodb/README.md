
# Module `aws/dynamodb`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `annotations` (default `{}`)
* `args` (default `["-jar","DynamoDBLocal.jar","-sharedDb","-dbPath","/data"]`)
* `command` (default `[]`)
* `configmap` (default `null`)
* `configmap_mount_path` (default `"/config"`)
* `env` (default `[]`)
* `env_file` (default `null`)
* `env_from` (default `[]`)
* `env_map` (default `{}`)
* `extra_volumes` (default `[]`)
* `image` (default `"amazon/dynamodb-local:1.22.0"`)
* `image_pull_secrets` (default `[]`)
* `name` (default `"dynamodb"`)
* `namespace` (required)
* `node_selector` (default `{}`)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":8000}]`)
* `post_start_command` (default `null`)
* `pvc` (default `null`)
* `pvc_mount_path` (default `"/data"`): pvc mount path
* `pvc_user` (default `"1000"`)
* `replicas` (default `1`)
* `resources` (default `{"requests":{"cpu":"250m","memory":"64Mi"}}`)
* `service_account_name` (default `null`)
* `sidecars` (default `[]`)

## Output Values
* `deployment`
* `name`
* `ports`
* `service`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)

