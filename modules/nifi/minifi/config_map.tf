resource "k8s_core_v1_config_map" "this" {
  data = {
    "bootstrap.conf" = <<-EOF
      # Java command to use when running MiNiFi
      java=java

      # Username to use when running MiNiFi. This value will be ignored on Windows.
      run.as=

      # Configure where MiNiFi's lib and conf directories live
      # When running as a Windows service set full paths instead of relative paths
      lib.dir=./lib
      conf.dir=./conf

      # How long to wait after telling MiNiFi to shutdown before explicitly killing the Process
      graceful.shutdown.seconds=20

      # The location for the configuration file
      # When running as a Windows service use the full path to the file
      nifi.minifi.config=./conf/config.yml

      # Notifiers to use for the associated agent, comma separated list of class names
      nifi.minifi.notifier.ingestors=org.apache.nifi.minifi.bootstrap.configuration.ingestors.PullHttpChangeIngestor

      #Pull HTTP change notifier configuration

      # Hostname on which to pull configurations from
      nifi.minifi.notifier.ingestors.pull.http.hostname=${var.c2_hostname}
      # Port on which to pull configurations from
      nifi.minifi.notifier.ingestors.pull.http.port=80
      # Path to pull configurations from
      nifi.minifi.notifier.ingestors.pull.http.path=/c2/config
      # Query string to pull configurations with
      nifi.minifi.notifier.ingestors.pull.http.query=class=minifi
      # Period on which to pull configurations from, defaults to 5 minutes if commented out
      nifi.minifi.notifier.ingestors.pull.http.period.ms=10000

      # Periodic Status Reporters to use for the associated agent, comma separated list of class names
      nifi.minifi.status.reporter.components=org.apache.nifi.minifi.bootstrap.status.reporters.StatusLogger

      # Periodic Status Logger configuration

      # The FlowStatus query to submit to the MiNiFi instance
      nifi.minifi.status.reporter.log.query=instance:health,bulletins
      # The log level at which the status will be logged
      nifi.minifi.status.reporter.log.level=INFO
      # The period (in milliseconds) at which to log the status
      nifi.minifi.status.reporter.log.period=10000

      # Disable JSR 199 so that we can use JSP's without running a JDK
      java.arg.1=-Dorg.apache.jasper.compiler.disablejsr199=true

      # JVM memory settings
      java.arg.2=-Xms256m
      java.arg.3=-Xmx256m

      # Enable Remote Debugging
      #java.arg.debug=-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=8000

      java.arg.4=-Djava.net.preferIPv4Stack=true

      # allowRestrictedHeaders is required for Cluster/Node communications to work properly
      java.arg.5=-Dsun.net.http.allowRestrictedHeaders=true
      java.arg.6=-Djava.protocol.handler.pkgs=sun.net.www.protocol

      # Sets the provider of SecureRandom to /dev/urandom to prevent blocking on VMs
      java.arg.7=-Djava.security.egd=file:/dev/urandom


      # The G1GC is still considered experimental but has proven to be very advantageous in providing great
      # performance without significant "stop-the-world" delays.
      #java.arg.13=-XX:+UseG1GC

      #Set headless mode by default
      java.arg.14=-Djava.awt.headless=true
      EOF
  }

  metadata {
    name      = var.name
    namespace = var.namespace
  }
}
