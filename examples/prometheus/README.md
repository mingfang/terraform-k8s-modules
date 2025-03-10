
# Module `prometheus`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"prometheus"`)
* `namespace` (default `"prometheus-example"`)
* `replicas` (default `1`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.alertmanager` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.prometheus` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.statsd-exporter` from `k8s`

## Child Modules
* `alertmanager` from [../../modules/prometheus/alertmanager](../../modules/prometheus/alertmanager)
* `nfs-server` from [../../modules/nfs-server-empty-dir](../../modules/nfs-server-empty-dir)
* `prometheus` from [../../modules/prometheus/prometheus](../../modules/prometheus/prometheus)
* `prometheus-storage` from [../../modules/kubernetes/storage-nfs](../../modules/kubernetes/storage-nfs)
* `statsd-exporter` from [../../modules/prometheus/statsd-exporter](../../modules/prometheus/statsd-exporter)

