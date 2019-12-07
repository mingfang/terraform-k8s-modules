/*
All possible settings are here
For multi-user = false https://github.com/eclipse/che/blob/master/assembly/assembly-wsmaster-war/src/main/webapp/WEB-INF/classes/che/che.properties
For multi-user = true https://github.com/eclipse/che/blob/master/assembly/assembly-wsmaster-war/src/main/webapp/WEB-INF/classes/che/multiuser.properties
- Uppercase all names
- Convert . to _
- Convert - to __ //double underscore
*/

locals {
  http_url = "${var.CHE_INFRA_KUBERNETES_TLS__ENABLED ? "https" : "http"}://${var.CHE_HOST}"
  ws_url   = "${var.CHE_INFRA_KUBERNETES_TLS__ENABLED ? "wss" : "ws"}://${var.CHE_HOST}"
}


resource "k8s_core_v1_config_map" "che" {
  data = {
    "CHE_API"                                                  = "${local.http_url}/api"
    "CHE_CORS_ALLOWED__ORIGINS"                                = "*"
    "CHE_CORS_ALLOW__CREDENTIALS"                              = "false"
    "CHE_CORS_ENABLED"                                         = "true"
    "CHE_DEBUG_SERVER"                                         = "true"
    "CHE_HOST"                                                 = var.CHE_HOST
    "CHE_INFRASTRUCTURE_ACTIVE"                                = "kubernetes"
    "CHE_INFRA_KUBERNETES_BOOTSTRAPPER_BINARY__URL"            = "${local.http_url}/agent-binaries/linux_amd64/bootstrapper/bootstrapper"
    "CHE_INFRA_KUBERNETES_CLUSTER__ROLE__NAME"                 = var.CHE_INFRA_KUBERNETES_CLUSTER__ROLE__NAME
    "CHE_INFRA_KUBERNETES_INGRESS_ANNOTATIONS__JSON"           = <<-EOF
      {"kubernetes.io/ingress.class": "${var.ingress_class}", "nginx.ingress.kubernetes.io/rewrite-target": "/$1","nginx.ingress.kubernetes.io/ssl-redirect": "false","nginx.ingress.kubernetes.io/proxy-connect-timeout": "3600","nginx.ingress.kubernetes.io/proxy-read-timeout": "3600"}
      EOF
    "CHE_INFRA_KUBERNETES_INGRESS_DOMAIN"                      = var.CHE_INFRA_KUBERNETES_INGRESS_DOMAIN
    "CHE_INFRA_KUBERNETES_INGRESS_PATH__TRANSFORM"             = "%s(.*)"
    "CHE_INFRA_KUBERNETES_MACHINE__START__TIMEOUT__MIN"        = "5"
    "CHE_INFRA_KUBERNETES_MASTER__URL"                         = ""
    "CHE_INFRA_KUBERNETES_NAMESPACE_DEFAULT"                   = var.CHE_INFRA_KUBERNETES_NAMESPACE_DEFAULT
    "CHE_INFRA_KUBERNETES_POD_SECURITY__CONTEXT_FS__GROUP"     = "1724"
    "CHE_INFRA_KUBERNETES_POD_SECURITY__CONTEXT_RUN__AS__USER" = "1724"
    "CHE_INFRA_KUBERNETES_PVC_PRECREATE__SUBPATHS"             = "true"
    "CHE_INFRA_KUBERNETES_PVC_NAME"                            = var.CHE_INFRA_KUBERNETES_PVC_NAME
    "CHE_INFRA_KUBERNETES_PVC_ACCESS__MODE"                    = var.CHE_INFRA_KUBERNETES_PVC_ACCESS__MODE
    "CHE_INFRA_KUBERNETES_PVC_QUANTITY"                        = var.CHE_INFRA_KUBERNETES_PVC_QUANTITY
    "CHE_INFRA_KUBERNETES_PVC_STORAGE__CLASS__NAME"            = var.CHE_INFRA_KUBERNETES_PVC_STORAGE__CLASS__NAME
    "CHE_INFRA_KUBERNETES_PVC_STRATEGY"                        = "common"
    "CHE_INFRA_KUBERNETES_SERVER__STRATEGY"                    = var.CHE_INFRA_KUBERNETES_SERVER__STRATEGY
    "CHE_INFRA_KUBERNETES_SERVICE__ACCOUNT__NAME"              = var.CHE_INFRA_KUBERNETES_SERVICE__ACCOUNT__NAME
    "CHE_INFRA_KUBERNETES_TLS__ENABLED"                        = var.CHE_INFRA_KUBERNETES_TLS__ENABLED
    "CHE_INFRA_KUBERNETES_TLS__SECRET"                         = ""
    "CHE_INFRA_KUBERNETES_TRUST__CERTS"                        = "false"
    "CHE_INFRA_KUBERNETES_WORKSPACE__START__TIMEOUT__MIN"      = "15"
    "CHE_KEYCLOAK_AUTH__SERVER__URL"                           = var.CHE_KEYCLOAK_AUTH__SERVER__URL
    "CHE_KEYCLOAK_CLIENT__ID"                                  = var.CHE_KEYCLOAK_CLIENT__ID
    "CHE_KEYCLOAK_REALM"                                       = var.CHE_KEYCLOAK_REALM
    "CHE_LIMITS_USER_WORKSPACES_RUN_COUNT"                     = var.CHE_LIMITS_USER_WORKSPACES_RUN_COUNT
    "CHE_LIMITS_WORKSPACE_IDLE_TIMEOUT"                        = "1800000"
    "CHE_LOCAL_CONF_DIR"                                       = "/etc/conf"
    "CHE_LOGGER_CONFIG"                                        = ""
    "CHE_LOGS_APPENDERS_IMPL"                                  = "plaintext"
    "CHE_LOGS_DIR"                                             = "/data/logs"
    "CHE_LOG_LEVEL"                                            = "INFO"
    "CHE_METRICS_ENABLED"                                      = "false"
    "CHE_MULTIUSER"                                            = var.CHE_MULTIUSER
    "CHE_OAUTH_GITHUB_CLIENTID"                                = ""
    "CHE_OAUTH_GITHUB_CLIENTSECRET"                            = ""
    "CHE_PORT"                                                 = "8080"
    "CHE_TRACING_ENABLED"                                      = "false"
    "CHE_WEBSOCKET_ENDPOINT"                                   = "${local.ws_url}/api/websocket"
    "CHE_WEBSOCKET_ENDPOINT__MINOR"                            = "${local.ws_url}/api/websocket-minor"
    "CHE_WORKSPACE_AUTO_START"                                 = "false"
    "CHE_WORKSPACE_DEVFILE__REGISTRY__URL"                     = var.CHE_WORKSPACE_DEVFILE__REGISTRY__URL
    "CHE_WORKSPACE_HTTPS__PROXY"                               = ""
    "CHE_WORKSPACE_HTTP__PROXY"                                = ""
    "CHE_WORKSPACE_JAVA__OPTIONS"                              = "-Xmx2000m"
    "CHE_WORKSPACE_MAVEN__OPTIONS"                             = "-Xmx20000m"
    "CHE_WORKSPACE_NO__PROXY"                                  = ""
    "CHE_WORKSPACE_PLUGIN__REGISTRY__URL"                      = var.CHE_WORKSPACE_PLUGIN__REGISTRY__URL
    "CHE_WSAGENT_CORS_ALLOWED__ORIGINS"                        = "NULL"
    "CHE_WSAGENT_CORS_ALLOW__CREDENTIALS"                      = "true"
    "CHE_WSAGENT_CORS_ENABLED"                                 = "true"
    "JAEGER_ENDPOINT"                                          = "http://jaeger-collector:14268/api/traces"
    "JAEGER_REPORTER_MAX_QUEUE_SIZE"                           = "10000"
    "JAEGER_SAMPLER_MANAGER_HOST_PORT"                         = "jaeger:5778"
    "JAEGER_SAMPLER_PARAM"                                     = "1"
    "JAEGER_SAMPLER_TYPE"                                      = "const"
    "JAEGER_SERVICE_NAME"                                      = "che-server"
    "JAVA_OPTS"                                                = "-XX:MaxRAMFraction=2 -XX:+UseParallelGC -XX:MinHeapFreeRatio=10 -XX:MaxHeapFreeRatio=20 -XX:GCTimeRatio=4 -XX:AdaptiveSizePolicyWeight=90 -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap -Dsun.zip.disableMemoryMapping=true -Xms20m "
  }
  metadata {
    labels = {
      "app"       = "che"
      "component" = "che"
    }
    name      = "che"
    namespace = var.namespace
  }
}