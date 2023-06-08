
# Module `appwrite`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"appwrite"`)
* `namespace` (default `"appwrite-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_core_v1_persistent_volume_claim.docker` from `k8s`
* `k8s_core_v1_persistent_volume_claim.functions` from `k8s`
* `k8s_core_v1_persistent_volume_claim.uploads` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.this` from `k8s`

## Child Modules
* `appwrite` from [../../modules/appwrite/appwrite](../../modules/appwrite/appwrite)
* `executor` from [../../modules/appwrite/appwrite](../../modules/appwrite/appwrite)
* `influxdb` from [../../modules/appwrite/influxdb](../../modules/appwrite/influxdb)
* `maintenance` from [../../modules/appwrite/maintenance](../../modules/appwrite/maintenance)
* `mariadb` from [../../modules/mysql](../../modules/mysql)
* `realtime` from [../../modules/appwrite/realtime](../../modules/appwrite/realtime)
* `redis` from [../../modules/redis](../../modules/redis)
* `schedule` from [../../modules/appwrite/schedule](../../modules/appwrite/schedule)
* `telegraf` from [../../modules/appwrite/telegraf](../../modules/appwrite/telegraf)
* `worker-audits` from [../../modules/appwrite/worker-audits](../../modules/appwrite/worker-audits)
* `worker-builds` from [../../modules/appwrite/appwrite](../../modules/appwrite/appwrite)
* `worker-database` from [../../modules/appwrite/worker-database](../../modules/appwrite/worker-database)
* `worker-deletes` from [../../modules/appwrite/worker-deletes](../../modules/appwrite/worker-deletes)
* `worker-functions` from [../../modules/appwrite/worker-functions](../../modules/appwrite/worker-functions)
* `worker-usage` from [../../modules/appwrite/worker-usage](../../modules/appwrite/worker-usage)
* `worker-webhook` from [../../modules/appwrite/worker-webhook](../../modules/appwrite/worker-webhook)

