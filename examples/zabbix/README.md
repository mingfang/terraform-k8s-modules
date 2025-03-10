
# Module `zabbix`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"zabbix"`)
* `namespace` (default `"zabbix-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_core_v1_service.zabbix-agent` from `k8s`
* `k8s_networking_k8s_io_v1_ingress.zabbix` from `k8s`

## Child Modules
* `kube-state-metrics` from [../../modules/generic-statefulset-service](../../modules/generic-statefulset-service)
* `postgres` from [../../modules/postgres](../../modules/postgres)
* `zabbix-agent` from [../../modules/generic-daemonset](../../modules/generic-daemonset)
* `zabbix-proxy` from [../../modules/generic-deployment-service](../../modules/generic-deployment-service)
* `zabbix-server` from [../../modules/generic-deployment-service](../../modules/generic-deployment-service)
* `zabbix-web` from [../../modules/generic-deployment-service](../../modules/generic-deployment-service)

