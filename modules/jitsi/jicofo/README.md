
# Module `jitsi/jicofo`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `ENABLE_AUTH` (default `"1"`)
* `JICOFO_AUTH_PASSWORD` (default `"passw0rd"`)
* `JICOFO_AUTH_USER` (default `"focus"`)
* `JICOFO_COMPONENT_SECRET` (default `"s3cr37"`)
* `JIGASI_BREWERY_MUC` (default `"jigasibrewery"`)
* `JVB_BREWERY_MUC` (default `"jvbbrewery"`)
* `TZ` (default `"America/New_York"`)
* `XMPP_AUTH_DOMAIN` (default `"auth"`)
* `XMPP_DOMAIN` (default `"meet"`)
* `XMPP_INTERNAL_MUC_DOMAIN` (default `"internal-muc"`)
* `XMPP_SERVER` (required)
* `image` (default `"registry.rebelsoft.com/jicofo"`)
* `name` (required)
* `namespace` (default `null`)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"dummy","port":80}]`)
* `replicas` (default `1`)

## Output Values
* `deployment`
* `name`
* `service`

## Child Modules
* `deployment-service` from `git::https://github.com/mingfang/terraform-k8s-modules.git//archetypes/deployment-service`

