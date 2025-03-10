
# Module `jaeger/cassandra-schema-job`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `image` (default `"jaegertracing/jaeger-cassandra-schema:1.20.0"`)
* `name` (default `"jaeger-cassandra-schema"`)
* `namespace` (required)

## Managed Resources
* `k8s_batch_v1beta1_cron_job.this` from `k8s`

