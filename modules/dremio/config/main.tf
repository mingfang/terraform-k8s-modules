resource "k8s_core_v1_config_map" "this" {
  data = {
    "core-site.xml" = <<-EOF
      <?xml version="1.0"?>
      <configuration>
        <!-- If you are editing any content in this file, please remove lines with double curly braces around them -->
        <!-- S3 Configuration Section -->
         <!-- ADLS Configuration Section -->
      </configuration>
      
      EOF
    "dremio-env" = <<-EOF
      #
      # Copyright (C) 2017-2018 Dremio Corporation
      #
      # Licensed under the Apache License, Version 2.0 (the "License");
      # you may not use this file except in compliance with the License.
      # You may obtain a copy of the License at
      #
      #     http://www.apache.org/licenses/LICENSE-2.0
      #
      # Unless required by applicable law or agreed to in writing, software
      # distributed under the License is distributed on an "AS IS" BASIS,
      # WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
      # See the License for the specific language governing permissions and
      # limitations under the License.
      #
      
      #
      # Dremio environment variables used by Dremio daemon
      #
      
      #
      # Directory where Dremio logs are written
      # Default to $DREMIO_HOME/log
      #
      #DREMIO_LOG_DIR=$${DREMIO_HOME}/log
      
      #
      # Send logs to console and not to log files. The DREMIO_LOG_DIR is ignored if set.
      #
      #DREMIO_LOG_TO_CONSOLE=1
      
      #
      # Directory where Dremio pidfiles are written
      # Default to $DREMIO_HOME/run
      #
      #DREMIO_PID_DIR=$${DREMIO_HOME}/run
      
      #
      # Max total memory size (in MB) for the Dremio process
      #
      # If not set, default to using max heap and max direct.
      #
      # If both max heap and max direct are set, this is not used
      # If one is set, the other is calculated as difference
      # of max memory and the one that is set.
      #
      #DREMIO_MAX_MEMORY_SIZE_MB=
      
      #
      # Max heap memory size (in MB) for the Dremio process
      #
      # Default to 4096 for server
      #
      #DREMIO_MAX_HEAP_MEMORY_SIZE_MB=4096
      
      #
      # Max direct memory size (in MB) for the Dremio process
      #
      # Default to 8192 for server
      #
      #DREMIO_MAX_DIRECT_MEMORY_SIZE_MB=8192
      
      #
      # Max permanent generation memory size (in MB) for the Dremio process
      # (Only used for Java 7)
      #
      # Default to 512 for server
      #
      #DREMIO_MAX_PERMGEN_MEMORY_SIZE_MB=512
      
      #
      # Garbage collection logging is enabled by default. Set the following
      # parameter to "no" to disable garbage collection logging.
      #
      #DREMIO_GC_LOGS_ENABLED="yes"
      
      #
      # The scheduling priority for the server
      #
      # Default to 0
      #
      # DREMIO_NICENESS=0
      #
      
      #
      # Number of seconds after which the server is killed forcibly it it hasn't stopped
      #
      # Default to 120
      #
      #DREMIO_STOP_TIMEOUT=120
      
      # Extra Java options - shared between dremio and dremio-admin commands
      #
      #DREMIO_JAVA_EXTRA_OPTS=
      
      # Extra Java options - client only (dremio-admin command)
      #
      #DREMIO_JAVA_CLIENT_EXTRA_OPTS=
      
      # Extra Java options - server only (dremio command)
      #
      #DREMIO_JAVA_SERVER_EXTRA_OPTS=
      
      EOF
    "dremio.conf" = <<-EOF
      #
      # Copyright (C) 2017-2018 Dremio Corporation
      #
      # Licensed under the Apache License, Version 2.0 (the "License");
      # you may not use this file except in compliance with the License.
      # You may obtain a copy of the License at
      #
      #     http://www.apache.org/licenses/LICENSE-2.0
      #
      # Unless required by applicable law or agreed to in writing, software
      # distributed under the License is distributed on an "AS IS" BASIS,
      # WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
      # See the License for the specific language governing permissions and
      # limitations under the License.
      #
      
      paths: {
        # the local path for dremio to store data.
        local: $${DREMIO_HOME}"/data"
      
        # the distributed path Dremio data including job results, downloads, uploads, etc
        #dist: "pdfs://"$${paths.local}"/pdfs"
      
        # If you are editing the uploads value in this file, please delete all the lines starting with double curly braces
      }
      
      services: {
        # The services running are controlled via command line options passed in
        # while starting the services via kubernetes. Updating the three values
        # below will not impact what services are running.
        #   coordinator.enabled: true,
        #   coordinator.master.enabled: true,
        #   executor.enabled: true
        #
        # Other service parameters can be customized via this file.
      }
      
      EOF
    "logback-access.xml" = <<-EOF
      <?xml version="1.0" encoding="UTF-8" ?>
      <!--
      
          Copyright (C) 2017-2018 Dremio Corporation
      
          Licensed under the Apache License, Version 2.0 (the "License");
          you may not use this file except in compliance with the License.
          You may obtain a copy of the License at
      
              http://www.apache.org/licenses/LICENSE-2.0
      
          Unless required by applicable law or agreed to in writing, software
          distributed under the License is distributed on an "AS IS" BASIS,
          WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
          See the License for the specific language governing permissions and
          limitations under the License.
      
      -->
      <configuration>
      
        <!-- The following appender is only available if dremio.log.path is defined -->
        <if condition='isDefined("dremio.log.path")'>
          <then>
            <appender name="access-text" class="ch.qos.logback.core.rolling.RollingFileAppender">
              <file>$${dremio.log.path}/access.log</file>
              <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
                <fileNamePattern>$${dremio.log.path}/archive/access.%d{yyyy-MM-dd}.log.gz</fileNamePattern>
                <maxHistory>30</maxHistory>
              </rollingPolicy>
      
              <encoder>
                <pattern>combined</pattern>
              </encoder>
            </appender>
      
            <appender-ref ref="access-text" />
          </then>
          <else>
            <appender name="console" class="ch.qos.logback.core.ConsoleAppender">
              <encoder>
                <pattern>combined</pattern>
              </encoder>
            </appender>
      
            <appender-ref ref="console"/>
          </else>
        </if>
      </configuration>
      
      EOF
    "logback.xml" = <<-EOF
      <?xml version="1.0" encoding="UTF-8" ?>
      <!--
      
          Copyright (C) 2017-2018 Dremio Corporation
      
          Licensed under the Apache License, Version 2.0 (the "License");
          you may not use this file except in compliance with the License.
          You may obtain a copy of the License at
      
              http://www.apache.org/licenses/LICENSE-2.0
      
          Unless required by applicable law or agreed to in writing, software
          distributed under the License is distributed on an "AS IS" BASIS,
          WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
          See the License for the specific language governing permissions and
          limitations under the License.
      
      -->
      <configuration>
        <contextListener class="ch.qos.logback.classic.jul.LevelChangePropagator"/>
        <appender name="console" class="ch.qos.logback.core.ConsoleAppender">
          <encoder>
            <pattern>%date{ISO8601} [%thread] %-5level %logger{36} - %msg%n</pattern>
          </encoder>
        </appender>
      
        <!-- The following appenders are only available if dremio.log.path is defined -->
        <if condition='isDefined("dremio.log.path")'>
          <then>
            <appender name="text" class="ch.qos.logback.core.rolling.RollingFileAppender">
              <file>$${dremio.log.path}/server.log</file>
              <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
                <fileNamePattern>$${dremio.log.path}/archive/server.%d{yyyy-MM-dd}.log.gz</fileNamePattern>
                <maxHistory>30</maxHistory>
              </rollingPolicy>
      
              <encoder>
                <pattern>%date{ISO8601} [%thread] %-5level %logger{36} - %msg%n</pattern>
              </encoder>
            </appender>
      
            <appender name="json" class="ch.qos.logback.core.rolling.RollingFileAppender">
              <file>$${dremio.log.path}/json/server.json</file>
              <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
                <fileNamePattern>$${dremio.log.path}/json/archive/server.%d{yyyy-MM-dd}.json.gz</fileNamePattern>
                <maxHistory>30</maxHistory>
              </rollingPolicy>
      
              <encoder class="net.logstash.logback.encoder.LoggingEventCompositeJsonEncoder">
                <providers>
                  <pattern><pattern>{"timestamp": "%date{ISO8601}", "host":"$${HOSTNAME}" }</pattern></pattern>
                  <threadName><fieldName>thread</fieldName></threadName>
                  <logLevel><fieldName>levelName</fieldName></logLevel>
                  <logLevelValue><fieldName>levelValue</fieldName></logLevelValue>
                  <loggerName><fieldName>logger</fieldName></loggerName>
                  <message><fieldName>message</fieldName></message>
                  <arguments />
                  <stackTrace />
                 </providers>
              </encoder>
            </appender>
      
            <appender name="query" class="ch.qos.logback.core.rolling.RollingFileAppender">
              <file>$${dremio.log.path}/queries.json</file>
              <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
                <fileNamePattern>$${dremio.log.path}/archive/queries.%d{yyyy-MM-dd}.json.gz</fileNamePattern>
                <maxHistory>30</maxHistory>
              </rollingPolicy>
      
              <encoder>
                <pattern>%msg%n</pattern>
              </encoder>
            </appender>
          </then>
        </if>
      
        <logger name="com.dremio">
          <level value="$${dremio.log.level:-info}"/>
        </logger>
      
        <logger name="query.logger">
          <level value="$${dremio.log.level:-info}"/>
          <if condition='isDefined("dremio.log.path")'>
            <then>
              <appender-ref ref="query"/>
            </then>
          </if>
        </logger>
      
      
        <root>
          <level value="$${dremio.log.root.level:-error}"/>
          <if condition='isDefined("dremio.log.path")'>
            <then>
              <appender-ref ref="text"/>
              <appender-ref ref="json"/>
            </then>
            <else>
              <appender-ref ref="console"/>
            </else>
          </if>
        </root>
      
      </configuration>
      
      EOF
  }
  metadata {
    name = var.name
    namespace = var.namespace
  }
}