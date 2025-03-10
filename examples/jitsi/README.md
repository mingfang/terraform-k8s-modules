
# Module `jitsi`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `NAT_HARVESTER_PUBLIC_ADDRESS` (default `"meet.rebelsoft.com"`)
* `load_balancer_ip` (default `"192.168.2.247"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_core_v1_service.jvb-udp` from `k8s`
* `k8s_extensions_v1beta1_ingress.web` from `k8s`

## Child Modules
* `jicofo` from [../../modules/jitsi/jicofo](../../modules/jitsi/jicofo)
* `jvb` from [../../modules/jitsi/jvb](../../modules/jitsi/jvb)
* `prosody` from [../../modules/jitsi/prosody](../../modules/jitsi/prosody)
* `web` from [../../modules/jitsi/web](../../modules/jitsi/web)

