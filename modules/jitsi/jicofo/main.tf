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
            name = "XMPP_DOMAIN"
            value = var.XMPP_DOMAIN
          },
          {
            name = "XMPP_AUTH_DOMAIN"
            value = var.XMPP_AUTH_DOMAIN
          },
          {
            name = "XMPP_INTERNAL_MUC_DOMAIN"
            value = var.XMPP_INTERNAL_MUC_DOMAIN
          },
          {
            name = "XMPP_SERVER"
            value = var.XMPP_SERVER
          },
          {
            name = "JICOFO_COMPONENT_SECRET"
            value = var.JICOFO_COMPONENT_SECRET
          },
          {
            name = "JICOFO_AUTH_USER"
            value = var.JICOFO_AUTH_USER
          },
          {
            name = "JICOFO_AUTH_PASSWORD"
            value = var.JICOFO_AUTH_PASSWORD
          },
          {
            name = "JVB_BREWERY_MUC"
            value = var.JVB_BREWERY_MUC
          },
          {
            name = "JIGASI_BREWERY_MUC"
            value = var.JIGASI_BREWERY_MUC
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
