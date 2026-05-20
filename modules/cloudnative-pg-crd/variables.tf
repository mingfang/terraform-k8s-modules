variable "name" {
  default     = "cloudnative-pg"
  description = "Release name for the CloudNativePG operator. Used for label identification."
}

variable "operator_version" {
  default     = "1.29.1"
  description = "CloudNativePG operator version to install. The corresponding YAML manifest must exist at cnpg-<version>.yaml in the module directory."
}

variable "plugin_operator_version" {
  default     = "0.12.0"
  description = "Barman Cloud Plugin operator version to install. The corresponding YAML manifest must exist at barman-cloud-<version>.yaml in the module directory."
}
