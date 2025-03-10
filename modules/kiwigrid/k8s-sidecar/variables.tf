variable "name" {}

variable "namespace" {}

variable "image" {
  default = "kiwigrid/k8s-sidecar:latest"
}

variable "env" {
  default = []
}

variable "annotations" {
  default = {}
}

variable "overrides" {
  default = {}
}

variable "resources" {
  default = {
    requests = {
      cpu    = "100m"
      memory = "10Mi"
    }
  }
}

variable "pvc_name" {
  default = null
}

variable "LABEL" {
  description = "Label that should be used for filtering"
}

variable "LABEL_VALUE" {
  default     = null
  description = "The value for the label you want to filter your resources on. Don't set a value to filter by any value"
}
variable "FOLDER_ANNOTATION" {
  default     = "k8s-sidecar-target-directory"
  description = "The annotation the sidecar will look for in configmaps to override the destination folder for files, defaults to \"k8s-sidecar-target-directory\""
}
variable "NAMESPACE" {
  default     = null
  description = "If specified, the sidecar will search for config-maps inside this namespace. Otherwise the namespace in which the sidecar is running will be used. It's also possible to specify ALL to search in all namespaces."
}
variable "RESOURCE" {
  default     = "configmap"
  description = "Resource type, which is monitored by the sidecar. Options: configmap (default), secret, both"
}
variable "METHOD" {
  default     = null
  description = "If METHOD is set with LIST, the sidecar will just list config-maps/secrets and exit. With SLEEP it will list all config-maps/secrets, then sleep for SLEEP_TIME seconds. Default is watch."
}
variable "SLEEP_TIME" {
  default     = 60
  description = "How many seconds to wait before updating config-maps/secrets when using SLEEP method."
}
variable "REQ_URL" {
  default     = null
  description = "URL to which send a request after a configmap/secret got reloaded"
}
variable "REQ_USERNAME" {
  default     = null
  description = "Username to use for basic authentication"
}
variable "REQ_METHOD" {
  default     = null
  description = "Request method GET(default) or POST"
}
variable "REQ_PAYLOAD" {
  default     = null
  description = "If you use POST you can also provide json payload"
}
variable "REQ_PASSWORD" {
  default     = null
  description = "Password to use for basic authentication"
}
variable "REQ_RETRY_TOTAL" {
  default     = 5
  description = "Total number of retries to allow"
}
variable "REQ_RETRY_CONNECT" {
  default     = 5
  description = "How many connection-related errors to retry on"
}
variable "REQ_RETRY_READ" {
  default     = 5
  description = "How many times to retry on read errors"
}
variable "REQ_RETRY_BACKOFF_FACTOR" {
  default     = 0.2
  description = "A backoff factor to apply between attempts after the second try"
}
variable "REQ_TIMEOUT" {
  default     = 10
  description = "How many seconds to wait for the server to send data before giving up"
}
variable "SCRIPT" {
  default     = null
  description = "Absolute path to shell script to execute after a configmap got reloaded. In runs before REQ"
}
variable "ERROR_THROTTLE_SLEEP" {
  default     = 5
  description = "How many seconds to wait before watching resources again when an error occurs"
}
variable "SKIP_TLS_VERIFY" {
  default     = null
  description = "Set to true to skip tls verification for kube api calls"
}
variable "UNIQUE_FILENAMES" {
  default     = null
  description = "Set to true to produce unique filenames where duplicate data keys exist between ConfigMaps and/or Secrets within the same or multiple Namespaces."
}
variable "DEFAULT_FILE_MODE" {
  default     = null
  description = "The default file system permission for every file. Use three digits (e.g. '500', '440', ...)"
}


