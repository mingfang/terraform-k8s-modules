
# Module `nfs-server-empty-dir`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `image` (default `"itsthenetwork/nfs-server-alpine"`)
* `medium` (default `""`)
* `name` (required)
* `namespace` (default `null`)
* `overrides` (default `{}`)
* `port` (default `2049`)

## Output Values
* `deployment`
* `mount_options`
* `name`
* `service`

## Child Modules
* `deployment-service` from [../../archetypes/deployment-service](../../archetypes/deployment-service)

