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
            name = "DOCKER_HOST_ADDRESS"
            value = var.NAT_HARVESTER_PUBLIC_ADDRESS
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
            name = "JVB_AUTH_USER"
            value = var.JVB_AUTH_USER
          },
          {
            name = "JVB_AUTH_PASSWORD"
            value = var.JVB_AUTH_PASSWORD
          },
          {
            name = "JVB_BREWERY_MUC"
            value = var.JVB_BREWERY_MUC
          },
          {
            name = "JVB_PORT"
            value = var.JVB_PORT
          },
          {
            name = "JVB_TCP_HARVESTER_DISABLED"
            value = var.JVB_TCP_HARVESTER_DISABLED
          },
          {
            name = "JVB_TCP_PORT"
            value = var.JVB_TCP_PORT
          },
          {
            name = "JVB_STUN_SERVERS"
            value = var.JVB_STUN_SERVERS
          },
          {
            name = "JVB_ENABLE_APIS"
            value = var.JVB_ENABLE_APIS
          },
          {
            name = "JICOFO_AUTH_USER"
            value = var.JICOFO_AUTH_USER
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
