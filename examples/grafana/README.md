
# Module `grafana`

Core Version Constraints:
* `>= 0.13`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)
* **pagerduty ([pagerduty/pagerduty](https://registry.terraform.io/providers/pagerduty/pagerduty/latest))** (any version)

## Input Variables
* `name` (default `"grafana"`)
* `namespace` (default `"grafana-example"`)
* `pagerduty_token` (default `"u+FavsUZYehAQCaxUV_Q"`)
* `storage_class_name` (default `"cephfs"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_core_v1_persistent_volume_claim.grafana` from `k8s`
* `k8s_core_v1_persistent_volume_claim.rules` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.alertmanager` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.grafana` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.loki` from `k8s`
* `pagerduty_service.ingress` from `pagerduty`
* `pagerduty_service_integration.ingress` from `pagerduty`

## Data Resources
* `data.pagerduty_escalation_policy.default` from `pagerduty`

## Child Modules
* `alertmanager` from [../../modules/prometheus/alertmanager](../../modules/prometheus/alertmanager)
* `alertmanager-config` from [../../modules/kubernetes/config-map](../../modules/kubernetes/config-map)
* `cassandra` from [../../modules/cassandra](../../modules/cassandra)
* `datasource` from [../../modules/kubernetes/config-map](../../modules/kubernetes/config-map)
* `grafana` from [../../modules/grafana/grafana](../../modules/grafana/grafana)
* `k8s-sidecar` from [../../modules/kiwigrid/k8s-sidecar](../../modules/kiwigrid/k8s-sidecar)
* `loki` from [../../modules/grafana/loki](../../modules/grafana/loki)
* `loki-rules-ingress` from [../../modules/grafana/loki-rule](../../modules/grafana/loki-rule)
* `promtail` from [../../modules/grafana/promtail](../../modules/grafana/promtail)

