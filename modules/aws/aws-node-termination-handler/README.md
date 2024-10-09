
# Module `aws/aws-node-termination-handler`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `CHECK_ASG_TAG_BEFORE_DRAINING` (default `"true"`): If true, check that the instance is tagged with 'aws-node-termination-handler/managed' as the key before draining the node
* `CORDON_ONLY` (default `"false"`): If true, nodes will be cordoned but not drained when an interruption event occurs.
* `DELETE_LOCAL_DATA` (default `"true"`): Tells kubectl to continue even if there are pods using emptyDir (local data that will be deleted when the node is drained).
* `EMIT_KUBERNETES_EVENTS` (default `"false"`): If true, Kubernetes events will be emitted when interruption events are received and when actions are taken on Kubernetes nodes. In IMDS Processor mode a default set of annotations with all the node metadata gathered from IMDS will be attached to each event. 
* `ENABLE_PROBES_SERVER` (default `"false"`): If true, start an http server exposing /healthz endpoint for probes.
* `ENABLE_PROMETHEUS_SERVER` (default `"false"`): If true, start an http server exposing /metrics endpoint for prometheus.
* `ENABLE_REBALANCE_DRAINING` (default `"false"`): If true, drain nodes when the rebalance recommendation notice is received
* `ENABLE_REBALANCE_MONITORING` (default `"false"`): If true, cordon nodes when the rebalance recommendation notice is received. If you'd like to drain the node in addition to cordoning, then also set enableRebalanceDraining.
* `ENABLE_SCHEDULED_EVENT_DRAINING` (default `"false"`): [EXPERIMENTAL] If true, drain nodes before the maintenance window starts for an EC2 instance scheduled event
* `ENABLE_SPOT_INTERRUPTION_DRAINING` (default `"true"`): If true, drain nodes when the spot interruption termination notice is received
* `GRACE_PERIOD` (default `"-1"`): (DEPRECATED: Renamed to podTerminationGracePeriod) The time in seconds given to each pod to terminate gracefully. If negative, the default value specified in the pod will be used, which defaults to 30 seconds if not specified.
* `IGNORE_DAEMON_SETS` (default `"true"`): Causes kubectl to skip daemon set managed pods
* `INSTANCE_METADATA_URL` (default `"http://169.254.169.254:80"`): The URL of EC2 instance metadata. This shouldn't need to be changed unless you are testing.
* `JSON_LOGGING` (default `"false"`): If true, use JSON-formatted logs instead of human readable logs.
* `KUBERNETES_EVENTS_EXTRA_ANNOTATIONS` (default `""`): A comma-separated list of key=value extra annotations to attach to all emitted Kubernetes events. Example: first=annotation,sample.annotation/number=two
* `LOG_LEVEL` (default `"INFO"`): Sets the log level (INFO, DEBUG, or ERROR)
* `MANAGED_ASG_TAG` (default `"aws-node-termination-handler/managed"`): The tag to ensure is on a node if checkASGTagBeforeDraining is true
* `METADATA_TRIES` (default `3`): The number of times to try requesting metadata. If you would like 2 retries, set metadata-tries to 3.
* `NODE_TERMINATION_GRACE_PERIOD` (default `"120"`): Period of time in seconds given to each NODE to terminate gracefully. Node draining will be scheduled based on this value to optimize the amount of compute time, but still safely drain the node before an event.
* `POD_TERMINATION_GRACE_PERIOD` (default `"-1"`): The time in seconds given to each pod to terminate gracefully. If negative, the default value specified in the pod will be used, which defaults to 30 seconds if not specified.
* `PROBES_SERVER_PORT` (default `8080`): Replaces the default HTTP port for exposing probes endpoint.
* `TAINT_NODE` (default `"false"`): If true, nodes will be tainted when an interruption event occurs. Currently used taint keys are aws-node-termination-handler/scheduled-maintenance, aws-node-termination-handler/spot-itn, aws-node-termination-handler/asg-lifecycle-termination and aws-node-termination-handler/rebalance-recommendation
* `WEBHOOK_HEADERS` (default `""`): Pass Webhook URL as a secret. Secret Key: webhookurl, Value: <WEBHOOK_URL>
* `WEBHOOK_PROXY` (default `""`): Uses the specified HTTP(S) proxy for sending webhooks
* `WEBHOOK_TEMPLATE` (default `""`): Replaces the default webhook message template.
* `WEBHOOK_URL` (default `""`): Posts event data to URL upon instance interruption action
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"public.ecr.aws/aws-ec2/aws-node-termination-handler:v1.21.0"`)
* `name` (default `"aws-node-termination-handler"`)
* `namespace` (default `"kube-system"`)
* `overrides` (default `{}`)
* `resources` (default `{"limits":{"cpu":"100m","memory":"128Mi"},"requests":{"cpu":"50m","memory":"64Mi"}}`)

## Output Values
* `daemonset`
* `name`

## Child Modules
* `daemonset` from [../../../archetypes/daemonset](../../../archetypes/daemonset)
* `rbac` from [../../../modules/kubernetes/rbac](../../../modules/kubernetes/rbac)

