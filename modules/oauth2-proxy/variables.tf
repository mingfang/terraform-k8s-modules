variable "name" {}

variable "namespace" {}

variable "image" {
  default = "quay.io/oauth2-proxy/oauth2-proxy:v6.1.1"
}

variable "replicas" {
  default = 1
}

variable ports {
  default = [
    {
      name = "http"
      port = 4180
    },
  ]
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

variable "OAUTH2_PROXY_REVERSE_PROXY" {
  default = true
  description = "should always be true when using an ingress controller"
}

variable "OAUTH2_PROXY_HTTP_ADDRESS" {
  default     = "0.0.0.0:4180"
  description = "make sure same as port"
}

variable "OAUTH2_PROXY_PROVIDER" {
  description = "keycloak"
}

variable "OAUTH2_PROXY_SCOPE" {
  default = "email"
  description = "must be set 'email' when provider is keycloak"
}

variable "OAUTH2_PROXY_CLIENT_ID" {
  default     = ""
  description = "client you have created"
}

variable "OAUTH2_PROXY_CLIENT_SECRET" {
  default     = ""
  description = "your client's secret"
}

variable "OAUTH2_PROXY_LOGIN_URL" {
  default     = ""
  description = "http(s)://<keycloak host>/realms/<your realm>/protocol/openid-connect/auth"
}

variable "OAUTH2_PROXY_REDEEM_URL" {
  default     = ""
  description = "http(s)://<keycloak host>/realms/<your realm>/protocol/openid-connect/token"
}
variable "OAUTH2_PROXY_VALIDATE_URL" {
  default     = ""
  description = "http(s)://<keycloak host>/realms/<your realm>/protocol/openid-connect/userinfo"
}

variable "OAUTH2_PROXY_KEYCLOAK_GROUP" {
  default     = ""
  description = "The group management in keycloak is using a tree. If you create a group named admin in keycloak you should define the ‘keycloak-group’ value to /admin."
}

variable "OAUTH2_PROXY_COOKIE_SECRET" {}

variable "OAUTH2_PROXY_COOKIE_DOMAINS" {
  default = ""
}

variable "OAUTH2_PROXY_EMAIL_DOMAINS" {
  default = "*"
}

variable "OAUTH2_PROXY_WHITELIST_DOMAINS" {
  default = ""
}
