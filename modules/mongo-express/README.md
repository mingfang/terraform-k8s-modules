
# Module `mongo-express`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `ME_CONFIG_MONGODB_ADMINPASSWORD` (default `""`)
* `ME_CONFIG_MONGODB_ADMINUSERNAME` (default `""`)
* `ME_CONFIG_MONGODB_URL` (required): mongodb://root:example@mongo:27017/
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"registry.rebelsoft.com/mongo-express:latest"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":8081}]`)
* `replicas` (default `1`)
* `resources` (default `{}`)

## Output Values
* `deployment`
* `name`
* `ports`
* `service`

## Child Modules
* `deployment-service` from [../../archetypes/deployment-service](../../archetypes/deployment-service)

