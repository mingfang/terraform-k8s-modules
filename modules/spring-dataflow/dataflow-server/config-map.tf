locals {
  environmentVariables = join(",", [
    "SPRING_CLOUD_CONFIG_ENABLED=false",
  ])

  config_map = {
    "application.yaml" = <<-EOF
      spring:
        cloud:
          dataflow:
            task:
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
          url: 'jdbc:mariadb://mysql-dataflow:3306/dataflow?useMysqlMetadata=true'
          driverClassName: org.mariadb.jdbc.Driver
          username: dataflow
          password: dataflow
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
