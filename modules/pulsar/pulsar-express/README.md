
# Module `pulsar/pulsar-express`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `PE_CONNECTION_URL` (required)
* `image` (default `"registry.rebelsoft.com/pulsar-express"`)
* `name` (required)
* `namespace` (default `null`)
* `overrides` (default `{}`)
* `port` (default `3000`)
* `replicas` (default `1`)

## Output Values
* `deployment`
* `name`
* `service`

## Child Modules
* `deployment-service` from `git::https://github.com/mingfang/terraform-k8s-modules.git//archetypes/deployment-service`

