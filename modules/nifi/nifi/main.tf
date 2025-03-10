locals {
  labels = {
    app     = var.name
    name    = var.name
    service = var.name
  }

  parameters = {
    name                 = var.name
    namespace            = var.namespace
    labels               = local.labels
    replicas             = var.replicas
    ports                = var.ports
    enable_service_links = false

    containers = [
      {
        name  = "nifi"
        image = var.image

/*
        command = [
          "sh",
          "-cx",
          <<-EOF
          scripts_dir='/opt/nifi/scripts'

          [ -f "$${scripts_dir}/common.sh" ] && . "$${scripts_dir}/common.sh"

          # Override JVM memory settings
          if [ ! -z "$${NIFI_JVM_HEAP_INIT}" ]; then
              prop_replace 'java.arg.2'       "-Xms$${NIFI_JVM_HEAP_INIT}" $${nifi_bootstrap_file}
          fi

          if [ ! -z "$${NIFI_JVM_HEAP_MAX}" ]; then
              prop_replace 'java.arg.3'       "-Xmx$${NIFI_JVM_HEAP_MAX}" $${nifi_bootstrap_file}
          fi

          if [ ! -z "$${NIFI_JVM_DEBUGGER}" ]; then
              uncomment "java.arg.debug" $${nifi_bootstrap_file}
          fi

          prop_replace 'nifi.web.https.port'                        ''
          prop_replace 'nifi.web.https.host'                        ''
          prop_replace 'nifi.web.http.port'                         "$${NIFI_WEB_HTTP_PORT}"
          prop_replace 'nifi.web.http.host'                         "$${NIFI_WEB_HTTP_HOST:-$HOSTNAME}"
          prop_replace 'nifi.remote.input.secure'                   'false'
          prop_replace 'nifi.cluster.protocol.is.secure'            'false'
          prop_replace 'nifi.security.keystore'                     ''
          prop_replace 'nifi.security.keystoreType'                 ''
          prop_replace 'nifi.security.truststore'                   ''
          prop_replace 'nifi.security.truststoreType'               ''
          prop_replace 'nifi.security.user.authorizer'              'managed-authorizer'
          prop_replace 'nifi.security.user.login.identity.provider' ''
          prop_replace 'keystore'                                   '' $${nifi_toolkit_props_file}
          prop_replace 'keystoreType'                               '' $${nifi_toolkit_props_file}
          prop_replace 'truststore'                                 '' $${nifi_toolkit_props_file}
          prop_replace 'truststoreType'                             '' $${nifi_toolkit_props_file}
          prop_replace 'baseUrl' "http://$${NIFI_WEB_HTTP_HOST:-$HOSTNAME}:$${NIFI_WEB_HTTP_PORT}" $${nifi_toolkit_props_file}

          prop_replace 'nifi.variable.registry.properties'    "$${NIFI_VARIABLE_REGISTRY_PROPERTIES:-}"
          prop_replace 'nifi.cluster.is.node'                         "$${NIFI_CLUSTER_IS_NODE:-false}"
          prop_replace 'nifi.cluster.node.address'                    "$${NIFI_CLUSTER_ADDRESS:-$HOSTNAME}"
          prop_replace 'nifi.cluster.node.protocol.port'              "$${NIFI_CLUSTER_NODE_PROTOCOL_PORT:-}"
          prop_replace 'nifi.cluster.node.protocol.max.threads'       "$${NIFI_CLUSTER_NODE_PROTOCOL_MAX_THREADS:-50}"
          prop_replace 'nifi.zookeeper.connect.string'                "$${NIFI_ZK_CONNECT_STRING:-}"
          prop_replace 'nifi.zookeeper.root.node'                     "$${NIFI_ZK_ROOT_NODE:-/nifi}"
          prop_replace 'nifi.cluster.flow.election.max.wait.time'     "$${NIFI_ELECTION_MAX_WAIT:-5 mins}"
          prop_replace 'nifi.cluster.flow.election.max.candidates'    "$${NIFI_ELECTION_MAX_CANDIDATES:-}"
          prop_replace 'nifi.web.proxy.context.path'                  "$${NIFI_WEB_PROXY_CONTEXT_PATH:-}"
          
          # Set analytics properties
          prop_replace 'nifi.analytics.predict.enabled'                   "$${NIFI_ANALYTICS_PREDICT_ENABLED:-false}"
          prop_replace 'nifi.analytics.predict.interval'                  "$${NIFI_ANALYTICS_PREDICT_INTERVAL:-3 mins}"
          prop_replace 'nifi.analytics.query.interval'                    "$${NIFI_ANALYTICS_QUERY_INTERVAL:-5 mins}"
          prop_replace 'nifi.analytics.connection.model.implementation'   "$${NIFI_ANALYTICS_MODEL_IMPLEMENTATION:-org.apache.nifi.controller.status.analytics.models.OrdinaryLeastSquares}"
          prop_replace 'nifi.analytics.connection.model.score.name'       "$${NIFI_ANALYTICS_MODEL_SCORE_NAME:-rSquared}"
          prop_replace 'nifi.analytics.connection.model.score.threshold'  "$${NIFI_ANALYTICS_MODEL_SCORE_THRESHOLD:-.90}"

          if [ -n "$${SINGLE_USER_CREDENTIALS_USERNAME}" ] && [ -n "$${SINGLE_USER_CREDENTIALS_PASSWORD}" ]; then
            $${NIFI_HOME}/bin/nifi.sh set-single-user-credentials "$${SINGLE_USER_CREDENTIALS_USERNAME}" "$${SINGLE_USER_CREDENTIALS_PASSWORD}"
          fi

          . "$${scripts_dir}/update_cluster_state_management.sh"

          "$${NIFI_HOME}/bin/nifi.sh" run &
          nifi_pid="$!"
          tail -F --pid=$${nifi_pid} "$${NIFI_HOME}/logs/nifi-app.log" &
          
          trap 'echo Received trapped signal, beginning shutdown...;./bin/nifi.sh stop;exit 0;' TERM HUP INT;
          trap ":" EXIT
          
          echo NiFi running with PID $${nifi_pid}.
          wait $${nifi_pid}
          EOF
        ]
*/

        env = concat([
          {
            name = "POD_NAME"

            value_from = {
              field_ref = {
                field_path = "metadata.name"
              }
            }
          },
          {
            name  = "NIFI_ELECTION_MAX_WAIT"
            value = "30 secs"
          },
          {
            name  = "NIFI_CLUSTER_NODE_PROTOCOL_PORT"
            value = "1025"
          },
          {
            name       = "NIFI_CLUSTER_ADDRESS"
            value_from = {
              field_ref = {
                field_path = "status.podIP"
              }
            }
          },
          {
            name       = "NIFI_WEB_HTTPS_HOST"
            value = "$(POD_NAME).${var.name}.${var.namespace}.svc.cluster.local"
          },
          {
            name  = "NIFI_WEB_HTTPS_PORT"
            value = var.ports.0.port
          },
        ], var.env)
      },
    ]
  }
}

module "statefulset-service" {
  source     = "../../../archetypes/statefulset-service"
  parameters = merge(local.parameters, var.overrides)
}