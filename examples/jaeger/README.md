
# Module `jaeger`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"jaeger"`)
* `namespace` (default `"jaeger-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.jaeger` from `k8s`

## Child Modules
* `cassandra` from [../../modules/cassandra](../../modules/cassandra)
* `cassandra-storage` from [../../modules/kubernetes/storage-nfs](../../modules/kubernetes/storage-nfs)
* `collector` from [../../modules/jaeger/collector](../../modules/jaeger/collector)
* `config` from [../../modules/jaeger/cassandra_config](../../modules/jaeger/cassandra_config)
* `job` from [../../modules/jaeger/cassandra-schema-job](../../modules/jaeger/cassandra-schema-job)
* `nfs-server` from [../../modules/nfs-server-empty-dir](../../modules/nfs-server-empty-dir)
* `query` from [../../modules/jaeger/query](../../modules/jaeger/query)

