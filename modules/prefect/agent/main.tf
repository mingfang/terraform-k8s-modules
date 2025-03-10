terraform {
  required_providers {
    k8s = {
      source  = "mingfang/k8s"
    }
  }
}

locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    replicas             = var.replicas
    enable_service_links = false

    containers = [
      {
        name  = "agent"
        image = var.image
        command = [
          "sh",
          "-cx",
          <<-EOF
          prefect agent start kubernetes
          EOF
        ]
        env   = concat([
          {
            name = "PREFECT__CLOUD__AGENT__AUTH_TOKEN"
            value = var.PREFECT__CLOUD__AGENT__AUTH_TOKEN
          },
          {
            name = "PREFECT__CLOUD__API"
            value = var.PREFECT__CLOUD__API
          },
          {
            name = "NAMESPACE"
            value = coalesce(var.JOB_NAMESPACE, var.namespace)
          },
          {
            name = "IMAGE_PULL_POLICY"
            value = var.IMAGE_PULL_POLICY
          },
          {
            name = "IMAGE_PULL_SECRETS"
            value = var.IMAGE_PULL_SECRETS
          },
          {
            name = "PREFECT__CLOUD__AGENT__LABELS"
            value = var.PREFECT__CLOUD__AGENT__LABELS
          },
          {
            name = "JOB_MEM_REQUEST"
            value = var.JOB_MEM_REQUEST
          },
          {
            name = "JOB_MEM_LIMIT"
            value = var.JOB_MEM_LIMIT
          },
          {
            name = "JOB_CPU_REQUEST"
            value = var.JOB_CPU_REQUEST
          },
          {
            name = "JOB_CPU_LIMIT"
            value = var.JOB_CPU_LIMIT
          },
          {
            name = "SERVICE_ACCOUNT_NAME"
            value = var.SERVICE_ACCOUNT_NAME
          },
          {
            name = "PREFECT__BACKEND"
            value = var.PREFECT__BACKEND
          },
          {
            name = "PREFECT__CLOUD__AGENT__AGENT_ADDRESS"
            value = var.PREFECT__CLOUD__AGENT__AGENT_ADDRESS
          },
        ],var.env)

        liveness_probe = {
          failure_threshold = 2
          http_get = {
            path = "/api/health"
            port = 8080
          }
          initial_delay_seconds = 40
          period_seconds = 40
        }

        resources = var.resources
      },
      {
        name  = "resource-manager"
        image = var.image
        command = [
          "sh",
          "-cx",
          <<-EOF
          python -c 'from prefect.agent.kubernetes import ResourceManager; ResourceManager().start()'
          EOF
        ]
        env   = concat([
          {
            name = "PREFECT__CLOUD__AGENT__AUTH_TOKEN"
            value = var.PREFECT__CLOUD__AGENT__AUTH_TOKEN
          },
          {
            name = "PREFECT__CLOUD__API"
            value = var.PREFECT__CLOUD__API
          },
          {
            name = "NAMESPACE"
            value = var.JOB_NAMESPACE
          },
        ],var.env)

        resources = var.resources
      }
    ]

    service_account_name = module.rbac.name
  }
}

module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}