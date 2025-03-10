
# Module `jitsi/web`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `DISABLE_HTTPS` (default `"1"`)
* `ENABLE_AUTH` (default `"1"`)
* `ENABLE_GUESTS` (default `"1"`)
* `ENABLE_HTTP_REDIRECT` (default `"0"`)
* `ENABLE_LETSENCRYPT` (default `"0"`)
* `JICOFO_AUTH_USER` (default `"focus"`)
* `LETSENCRYPT_DOMAIN` (default `""`)
* `LETSENCRYPT_EMAIL` (default `""`)
* `TZ` (default `"America/New_York"`)
* `XMPP_AUTH_DOMAIN` (default `"auth"`)
* `XMPP_BOSH_URL_BASE` (required)
* `XMPP_DOMAIN` (default `"meet"`)
* `XMPP_GUEST_DOMAIN` (default `"guest"`)
* `XMPP_MUC_DOMAIN` (default `"muc"`)
* `image` (default `"registry.rebelsoft.com/web"`)
* `name` (required)
* `namespace` (default `null`)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":80},{"name":"https","port":443}]`)
* `replicas` (default `1`)

## Output Values
* `deployment`
* `name`
* `service`

## Child Modules
* `deployment-service` from `git::https://github.com/mingfang/terraform-k8s-modules.git//archetypes/deployment-service`

