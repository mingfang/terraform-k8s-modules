
# Module `openwhisk/whisk-config`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"openwhisk-whisk.config"`)
* `namespace` (required)
* `whisk_api_host_name` (required)
* `whisk_api_host_port` (required)
* `whisk_api_host_proto` (default `"https"`)

## Output Values
* `name`

## Child Modules
* `config` from [../../kubernetes/config-map](../../kubernetes/config-map)

