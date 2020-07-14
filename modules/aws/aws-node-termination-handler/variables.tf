variable "namespace" {
  default = "kube-system"
}

variable "DELETE_LOCAL_DATA" {
  default = ""
}
variable "IGNORE_DAEMON_SETS" {
  default = ""
}
variable "GRACE_PERIOD" {
  default = ""
}
variable "POD_TERMINATION_GRACE_PERIOD" {
  default = ""
}
variable "INSTANCE_METADATA_URL" {
  default = ""
}
variable "NODE_TERMINATION_GRACE_PERIOD" {
  default = ""
}
variable "WEBHOOK_URL" {
  default = ""
}
variable "WEBHOOK_HEADERS" {
  default = ""
}
variable "WEBHOOK_TEMPLATE" {
  default = ""
}
variable "ENABLE_SPOT_INTERRUPTION_DRAINING" {
  default = ""
}
variable "ENABLE_SCHEDULED_EVENT_DRAINING" {
  default = ""
}
variable "METADATA_TRIES" {
  default = ""
}
variable "CORDON_ONLY" {
  default = ""
}
variable "JSON_LOGGING" {
  default = ""
}
variable "WEBHOOK_PROXY" {
  default = ""
}
variable "UPTIME_FROM_FILE" {
  default = ""
}
variable "ENABLE_PROMETHEUS_SERVER" {
  default = "false"
}
variable "TAINT_NODE" {
  default = "false"
}
