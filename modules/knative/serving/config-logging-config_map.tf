resource "k8s_core_v1_config_map" "config-logging" {
  data = {
    "_example" = <<-EOF
      ################################
      #                              #
      #    EXAMPLE CONFIGURATION     #
      #                              #
      ################################
      
      # This block is not actually functional configuration,
      # but serves to illustrate the available configuration
      # options and document them in a way that is accessible
      # to users that `kubectl edit` this config map.
      #
      # These sample configuration options may be copied out of
      # this block and unindented to actually change the configuration.
      
      # Common configuration for all Knative codebase
      zap-logger-config: |
        {
          "level": "info",
          "development": false,
          "outputPaths": ["stdout"],
          "errorOutputPaths": ["stderr"],
          "encoding": "json",
          "encoderConfig": {
            "timeKey": "ts",
            "levelKey": "level",
            "nameKey": "logger",
            "callerKey": "caller",
            "messageKey": "msg",
            "stacktraceKey": "stacktrace",
            "lineEnding": "",
            "levelEncoder": "",
            "timeEncoder": "iso8601",
            "durationEncoder": "",
            "callerEncoder": ""
          }
        }
      
      # Log level overrides
      # For all components except the autoscaler and queue proxy,
      # changes are be picked up immediately.
      # For autoscaler and queue proxy, changes require recreation of the pods.
      loglevel.controller: "info"
      loglevel.autoscaler: "info"
      loglevel.queueproxy: "info"
      loglevel.webhook: "info"
      loglevel.activator: "info"
      
      EOF
  }
  metadata {
    labels = {
      "serving.knative.dev/release" = "devel"
    }
    name = "config-logging"
    namespace = "${var.namespace}"
  }
}