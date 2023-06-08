
# Module `tooljet/server`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `CHECK_FOR_UPDATES` (default `"0"`): Self-hosted version of ToolJet pings our server to fetch the latest product updates every 24 hours. You can disable this by setting the value of CHECK_FOR_UPDATES environment variable to 0
* `COMMENT_FEATURE_ENABLE` (default `"true"`): enable/disable the feature that allows you to add comments on the canvas.
* `LOCKBOX_MASTER_KEY` (required): 32 byte hexadecimal string.
* `PG_DB` (required)
* `PG_HOST` (required)
* `PG_PASS` (required)
* `PG_USER` (required)
* `SECRET_KEY_BASE` (required): 64 byte hexadecimal string to encrypt session cookies.
* `SERVE_CLIENT` (default `"false"`)
* `TOOLJET_HOST` (required): the public URL of ToolJet client
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"tooljet/tooljet-server-ce:v1.14.0"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":3000}]`)
* `replicas` (default `1`)
* `resources` (default `{"requests":{"cpu":"125m","memory":"64Mi"}}`)

## Output Values
* `deployment`
* `name`
* `ports`
* `service`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)

