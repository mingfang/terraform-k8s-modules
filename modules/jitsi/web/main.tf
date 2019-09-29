/**
 * Documentation
 *
 * terraform-docs --sort-inputs-by-required --with-aggregate-type-defaults md
 *
 */

locals {
  labels = {
    app     = var.name
    name    = var.name
    service = var.name
  }

  parameters = {
    name      = var.name
    namespace = var.namespace
    labels    = local.labels
    replicas  = var.replicas
    ports     = var.ports

    enable_service_links = false

    containers = [
      {
        name  = "jvb"
        image = var.image

        env = [
          {
            name = "ENABLE_AUTH"
            value = var.ENABLE_AUTH
          },
          {
            name = "ENABLE_GUESTS"
            value = var.ENABLE_GUESTS
          },
          {
            name = "ENABLE_LETSENCRYPT"
            value = var.ENABLE_LETSENCRYPT
          },
          {
            name = "ENABLE_HTTP_REDIRECT"
            value = var.ENABLE_HTTP_REDIRECT
          },
          {
            name = "DISABLE_HTTPS"
            value = var.DISABLE_HTTPS
          },
          {
            name = "JICOFO_AUTH_USER"
            value = var.JICOFO_AUTH_USER
          },
          {
            name = "LETSENCRYPT_DOMAIN"
            value = var.LETSENCRYPT_DOMAIN
          },
          {
            name = "LETSENCRYPT_EMAIL"
            value = var.LETSENCRYPT_EMAIL
          },
          {
            name = "XMPP_DOMAIN"
            value = var.XMPP_DOMAIN
          },
          {
            name = "XMPP_AUTH_DOMAIN"
            value = var.XMPP_AUTH_DOMAIN
          },
          {
            name = "XMPP_BOSH_URL_BASE"
            value = var.XMPP_BOSH_URL_BASE
          },
          {
            name = "XMPP_GUEST_DOMAIN"
            value = var.XMPP_GUEST_DOMAIN
          },
          {
            name = "XMPP_MUC_DOMAIN"
            value = var.XMPP_MUC_DOMAIN
          },
          {
            name = "TZ"
            value = var.TZ
          },
        ]
      }
    ]
  }
}


module "deployment-service" {
  source     = "git::https://github.com/mingfang/terraform-provider-k8s.git//archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
