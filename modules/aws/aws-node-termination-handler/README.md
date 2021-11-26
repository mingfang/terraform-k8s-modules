
# Module `aws/aws-node-termination-handler`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `CORDON_ONLY` (default `""`)
* `DELETE_LOCAL_DATA` (default `""`)
* `ENABLE_PROMETHEUS_SERVER` (default `"false"`)
* `ENABLE_SCHEDULED_EVENT_DRAINING` (default `""`)
* `ENABLE_SPOT_INTERRUPTION_DRAINING` (default `""`)
* `GRACE_PERIOD` (default `""`)
* `IGNORE_DAEMON_SETS` (default `""`)
* `INSTANCE_METADATA_URL` (default `""`)
* `JSON_LOGGING` (default `""`)
* `METADATA_TRIES` (default `""`)
* `NODE_TERMINATION_GRACE_PERIOD` (default `""`)
* `POD_TERMINATION_GRACE_PERIOD` (default `""`)
* `TAINT_NODE` (default `"false"`)
* `UPTIME_FROM_FILE` (default `""`)
* `WEBHOOK_HEADERS` (default `""`)
* `WEBHOOK_PROXY` (default `""`)
* `WEBHOOK_TEMPLATE` (default `""`)
* `WEBHOOK_URL` (default `""`)
* `namespace` (default `"kube-system"`)

## Managed Resources
* `k8s_apps_v1_daemon_set.aws_node_termination_handler` from `k8s`
* `k8s_core_v1_service_account.aws_node_termination_handler` from `k8s`
* `k8s_policy_v1beta1_pod_security_policy.aws_node_termination_handler` from `k8s`
* `k8s_rbac_authorization_k8s_io_v1_cluster_role.aws_node_termination_handler` from `k8s`
* `k8s_rbac_authorization_k8s_io_v1_cluster_role.aws_node_termination_handler_psp` from `k8s`
* `k8s_rbac_authorization_k8s_io_v1_cluster_role_binding.aws_node_termination_handler` from `k8s`
* `k8s_rbac_authorization_k8s_io_v1_role_binding.aws_node_termination_handler_psp` from `k8s`

