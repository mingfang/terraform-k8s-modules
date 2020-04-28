locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    replicas             = var.replicas
    ports                = var.ports
    enable_service_links = false

    containers = [
      {
        name  = "oauth2-proxy"
        image = var.image
        env = concat([
          {
            name  = "OAUTH2_PROXY_HTTP_ADDRESS"
            value = var.OAUTH2_PROXY_HTTP_ADDRESS
          },
          {
            name  = "OAUTH2_PROXY_PROVIDER"
            value = var.OAUTH2_PROXY_PROVIDER
          },
          {
            name  = "OAUTH2_PROXY_CLIENT_ID"
            value = var.OAUTH2_PROXY_CLIENT_ID
          },
          {
            name  = "OAUTH2_PROXY_CLIENT_SECRET"
            value = var.OAUTH2_PROXY_CLIENT_SECRET
          },
          {
            name  = "OAUTH2_PROXY_LOGIN_URL"
            value = var.OAUTH2_PROXY_LOGIN_URL
          },
          {
            name  = "OAUTH2_PROXY_REDEEM_URL"
            value = var.OAUTH2_PROXY_REDEEM_URL
          },
          {
            name  = "OAUTH2_PROXY_VALIDATE_URL"
            value = var.OAUTH2_PROXY_VALIDATE_URL
          },
          {
            name  = "OAUTH2_PROXY_KEYCLOAK_GROUP"
            value = var.OAUTH2_PROXY_KEYCLOAK_GROUP
          },
          {
            name  = "OAUTH2_PROXY_COOKIE_SECRET"
            value = var.OAUTH2_PROXY_COOKIE_SECRET
          },
          {
            name  = "OAUTH2_PROXY_COOKIE_DOMAIN"
            value = var.OAUTH2_PROXY_COOKIE_DOMAIN
          },
          {
            name  = "OAUTH2_PROXY_EMAIL_DOMAINS"
            value = var.OAUTH2_PROXY_EMAIL_DOMAINS
          },
          {
            name  = "OAUTH2_PROXY_WHITELIST_DOMAINS"
            value = var.OAUTH2_PROXY_WHITELIST_DOMAINS
          },
        ], var.env)
      },
    ]
  }
}

module "deployment-service" {
  source     = "../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}