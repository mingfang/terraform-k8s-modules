variable "name" {
  default = "aws-node-termination-handler"
}

variable "namespace" {
  default = "kube-system"
}

variable "image" {
  default = "public.ecr.aws/aws-ec2/aws-node-termination-handler:v1.21.0"
}

variable "env" {
  default = []
}

variable "annotations" {
  default = {}
}

variable "resources" {
  default = {
    limits = {
      cpu    = "100m"
      memory = "128Mi"
    }
    requests = {
      cpu    = "50m"
      memory = "64Mi"
    }
  }
}

variable "overrides" {
  default = {}
}

variable "DELETE_LOCAL_DATA" {
  default     = "true"
  description = "Tells kubectl to continue even if there are pods using emptyDir (local data that will be deleted when the node is drained)."
}
variable "GRACE_PERIOD" {
  default     = "-1"
  description = "(DEPRECATED: Renamed to podTerminationGracePeriod) The time in seconds given to each pod to terminate gracefully. If negative, the default value specified in the pod will be used, which defaults to 30 seconds if not specified."
}
variable "POD_TERMINATION_GRACE_PERIOD" {
  default     = "-1"
  description = "The time in seconds given to each pod to terminate gracefully. If negative, the default value specified in the pod will be used, which defaults to 30 seconds if not specified."
}
variable "NODE_TERMINATION_GRACE_PERIOD" {
  default     = "120"
  description = "Period of time in seconds given to each NODE to terminate gracefully. Node draining will be scheduled based on this value to optimize the amount of compute time, but still safely drain the node before an event."
}
variable "IGNORE_DAEMON_SETS" {
  default     = "true"
  description = "Causes kubectl to skip daemon set managed pods"
}
variable "INSTANCE_METADATA_URL" {
  default     = "http://169.254.169.254:80"
  description = "The URL of EC2 instance metadata. This shouldn't need to be changed unless you are testing."
}
variable "WEBHOOK_URL" {
  default     = ""
  description = "Posts event data to URL upon instance interruption action"
}
variable "WEBHOOK_PROXY" {
  default     = ""
  description = "Uses the specified HTTP(S) proxy for sending webhooks"
}
variable "WEBHOOK_HEADERS" {
  default     = ""
  description = "Pass Webhook URL as a secret. Secret Key: webhookurl, Value: <WEBHOOK_URL>"
}
variable "WEBHOOK_TEMPLATE" {
  default     = ""
  description = "Replaces the default webhook message template."
}
variable "METADATA_TRIES" {
  default     = 3
  description = "The number of times to try requesting metadata. If you would like 2 retries, set metadata-tries to 3."
}
variable "CORDON_ONLY" {
  default     = "false"
  description = "If true, nodes will be cordoned but not drained when an interruption event occurs."
}
variable "TAINT_NODE" {
  default     = "false"
  description = "If true, nodes will be tainted when an interruption event occurs. Currently used taint keys are aws-node-termination-handler/scheduled-maintenance, aws-node-termination-handler/spot-itn, aws-node-termination-handler/asg-lifecycle-termination and aws-node-termination-handler/rebalance-recommendation"
}
variable "JSON_LOGGING" {
  default     = "false"
  description = "If true, use JSON-formatted logs instead of human readable logs."
}
variable "LOG_LEVEL" {
  default     = "INFO"
  description = "Sets the log level (INFO, DEBUG, or ERROR)"
}
variable "ENABLE_PROMETHEUS_SERVER" {
  default     = "false"
  description = "If true, start an http server exposing /metrics endpoint for prometheus."
}
variable "ENABLE_PROBES_SERVER" {
  default     = "false"
  description = "If true, start an http server exposing /healthz endpoint for probes."
}
variable "PROBES_SERVER_PORT" {
  default     = 8080
  description = "Replaces the default HTTP port for exposing probes endpoint."
}
variable "EMIT_KUBERNETES_EVENTS" {
  default     = "false"
  description = "If true, Kubernetes events will be emitted when interruption events are received and when actions are taken on Kubernetes nodes. In IMDS Processor mode a default set of annotations with all the node metadata gathered from IMDS will be attached to each event. "
}
variable "KUBERNETES_EVENTS_EXTRA_ANNOTATIONS" {
  default     = ""
  description = "A comma-separated list of key=value extra annotations to attach to all emitted Kubernetes events. Example: first=annotation,sample.annotation/number=two"
}
variable "CHECK_ASG_TAG_BEFORE_DRAINING" {
  default     = "true"
  description = "If true, check that the instance is tagged with 'aws-node-termination-handler/managed' as the key before draining the node"
}
variable "MANAGED_ASG_TAG" {
  default     = "aws-node-termination-handler/managed"
  description = "The tag to ensure is on a node if checkASGTagBeforeDraining is true"
}
variable "ENABLE_SCHEDULED_EVENT_DRAINING" {
  default     = "false"
  description = "[EXPERIMENTAL] If true, drain nodes before the maintenance window starts for an EC2 instance scheduled event"
}
variable "ENABLE_SPOT_INTERRUPTION_DRAINING" {
  default     = "true"
  description = "If true, drain nodes when the spot interruption termination notice is received"
}
variable "ENABLE_REBALANCE_DRAINING" {
  default     = "false"
  description = "If true, drain nodes when the rebalance recommendation notice is received"
}
variable "ENABLE_REBALANCE_MONITORING" {
  default     = "false"
  description = "If true, cordon nodes when the rebalance recommendation notice is received. If you'd like to drain the node in addition to cordoning, then also set enableRebalanceDraining."
}
