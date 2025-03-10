locals {
  environmentVariables = join(",", [
    "SPRING_RABBITMQ_HOST=${var.RABBITMQ_HOST}",
    "SPRING_RABBITMQ_PORT=${var.RABBITMQ_PORT}",
    "SPRING_RABBITMQ_USERNAME=${var.RABBITMQ_USERNAME}",
    "SPRING_RABBITMQ_PASSWORD=${var.RABBITMQ_PASSWORD}",
    "SPRING_RABBITMQ_VIRTUAL_HOST=${var.RABBITMQ_VIRTUAL_HOST}",
    "SPRING_CLOUD_CONFIG_ENABLED=false",
  ])

  config_map = {
    "application.yaml" = <<-EOF
      spring:
        cloud:
          skipper:
            server:
              platform:
                kubernetes:
                  accounts:
                    default:
                      environmentVariables: '${local.environmentVariables}'
                      limits:
                        cpu: 500m
                        memory: 1024Mi
                      readinessProbeDelay: 120
                      livenessProbeDelay: 90
                      podSecurityContext:
                        runAsUser: 1001
        jpa:
          properties:
            hibernate:
              dialect: org.hibernate.dialect.MariaDB102Dialect
        datasource:
          url: 'jdbc:mariadb://mysql-skipper:3306/skipper?useMysqlMetadata=true'
          driverClassName: org.mariadb.jdbc.Driver
          username: skipper
          password: skipper
          testOnBorrow: true
          validationQuery: "SELECT 1"
      EOF
  }
}

module "config" {
  source    = "../../kubernetes/config-map"
  name      = var.name
  namespace = var.namespace
  from-map  = local.config_map
}
