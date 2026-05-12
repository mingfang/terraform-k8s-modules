variable "name" {
  default     = "cloudnative-pg"
  description = "Release name for the CloudNativePG operator. Used for label identification."
}

variable "operator_version" {
  default     = "1.29.0"
  description = "CloudNativePG operator version to install. See https://github.com/cloudnative-pg/cloudnative-pg/releases"
}
