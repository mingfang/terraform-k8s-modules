
# Module `jitsi/jvb`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `JICOFO_AUTH_USER` (default `"focus"`)
* `JVB_AUTH_PASSWORD` (default `"passw0rd"`)
* `JVB_AUTH_USER` (default `"jvb"`)
* `JVB_BREWERY_MUC` (default `"jvbbrewery"`)
* `JVB_ENABLE_APIS` (default `"rest,colibri,xmpp"`)
* `JVB_PORT` (default `10000`)
* `JVB_STUN_SERVERS` (default `"stun.l.google.com:19302,stun1.l.google.com:19302,stun2.l.google.com:19302"`)
* `JVB_TCP_HARVESTER_DISABLED` (default `"true"`)
* `JVB_TCP_PORT` (default `4443`)
* `NAT_HARVESTER_PUBLIC_ADDRESS` (required)
* `TZ` (default `"America/New_York"`)
* `XMPP_AUTH_DOMAIN` (default `"auth"`)
* `XMPP_INTERNAL_MUC_DOMAIN` (default `"internal-muc"`)
* `XMPP_SERVER` (required)
* `image` (default `"registry.rebelsoft.com/jvb"`)
* `name` (required)
* `namespace` (default `null`)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"tcp","port":4443},{"name":"udp","port":10000,"protocol":"UDP"}]`)
* `replicas` (default `1`)

## Output Values
* `deployment`
* `name`
* `service`

## Child Modules
* `deployment-service` from `git::https://github.com/mingfang/terraform-k8s-modules.git//archetypes/deployment-service`

