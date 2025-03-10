
# Module `openwhisk/nginx`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `apigateway_fqdn` (required): <apigateway>.<namespace>.svc.cluster.local
* `controller_fqdn` (required): <controller>.<namespace>.svc.cluster.local
* `name` (required)
* `namespace` (required)
* `ports` (default `[{"name":"http","port":80}]`)

## Output Values
* `deployment`
* `name`
* `ports`
* `service`

## Child Modules
* `nginx` from [../../nginx](../../nginx)

