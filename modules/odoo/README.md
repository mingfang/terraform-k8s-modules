
# Module `odoo`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `HOST` (required)
* `PASSWORD` (required)
* `PORT` (required)
* `USER` (required)
* `additional_containers` (default `[]`)
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"odoo:14.0"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":8069}]`)
* `pvc` (default `null`)
* `replicas` (default `1`)

## Output Values
* `deployment`
* `name`
* `ports`
* `service`

## Child Modules
* `deployment-service` from [../../archetypes/deployment-service](../../archetypes/deployment-service)

