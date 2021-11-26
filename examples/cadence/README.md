
# Module `cadence`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"cadence"`)
* `namespace` (default `"cadence-example"`)
* `replicas` (default `3`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_extensions_v1beta1_ingress.alertmanager` from `k8s`
* `k8s_extensions_v1beta1_ingress.cadence-web` from `k8s`
* `k8s_extensions_v1beta1_ingress.elasticsearch` from `k8s`
* `k8s_extensions_v1beta1_ingress.prometheus` from `k8s`

## Child Modules
* `alertmanager` from [../../modules/prometheus/alertmanager](../../modules/prometheus/alertmanager)
* `cadence-frontend` from [../../modules/cadence/server](../../modules/cadence/server)
* `cadence-history` from [../../modules/cadence/server](../../modules/cadence/server)
* `cadence-matching` from [../../modules/cadence/server](../../modules/cadence/server)
* `cadence-web` from [../../modules/cadence/web](../../modules/cadence/web)
* `cadence-worker` from [../../modules/cadence/server](../../modules/cadence/server)
* `cassandra` from [../../modules/cassandra](../../modules/cassandra)
* `cassandra-storage` from [../../modules/kubernetes/storage-nfs](../../modules/kubernetes/storage-nfs)
* `elasticsearch` from [../../modules/elasticsearch](../../modules/elasticsearch)
* `elasticsearch_storage` from [../../modules/kubernetes/storage-nfs](../../modules/kubernetes/storage-nfs)
* `kafka` from [../../modules/kafka](../../modules/kafka)
* `kafka_storage` from [../../modules/kubernetes/storage-nfs](../../modules/kubernetes/storage-nfs)
* `nfs-server` from [../../modules/nfs-server-empty-dir](../../modules/nfs-server-empty-dir)
* `prometheus` from [../../modules/prometheus/prometheus](../../modules/prometheus/prometheus)
* `prometheus-storage` from [../../modules/kubernetes/storage-nfs](../../modules/kubernetes/storage-nfs)
* `statsd-exporter` from [../../modules/prometheus/statsd-exporter](../../modules/prometheus/statsd-exporter)
* `zookeeper` from [../../modules/zookeeper](../../modules/zookeeper)
* `zookeeper_storage` from [../../modules/kubernetes/storage-nfs](../../modules/kubernetes/storage-nfs)

