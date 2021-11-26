
# Module `sentry`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"sentry"`)
* `namespace` (default `"sentry-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.this` from `k8s`

## Child Modules
* `clickhose` from [../../modules/clickhouse](../../modules/clickhouse)
* `cron` from [../../modules/sentry/cron](../../modules/sentry/cron)
* `env_configmap` from [../../modules/kubernetes/config-map](../../modules/kubernetes/config-map)
* `etc_configmap` from [../../modules/sentry/config](../../modules/sentry/config)
* `kafka` from [../../modules/kafka](../../modules/kafka)
* `memcached` from [../../modules/memcached](../../modules/memcached)
* `postgres` from [../../modules/postgres](../../modules/postgres)
* `redis` from [../../modules/redis](../../modules/redis)
* `sentry` from [../../modules/sentry/sentry](../../modules/sentry/sentry)
* `snuba` from [../../modules/sentry/snuba](../../modules/sentry/snuba)
* `symbolicator` from [../../modules/sentry/symbolicator](../../modules/sentry/symbolicator)
* `worker` from [../../modules/sentry/worker](../../modules/sentry/worker)
* `zookeeper` from [../../modules/zookeeper](../../modules/zookeeper)

