resource "k8s_core_v1_config_map" "this" {
  data = {
    "settings.xml" = <<-EOF
      <!-- CUSTOM settings.xml for KIE Execution Server
          *********************************************
          - This is the custom settings.xml file used for KIE Execution Server to download the artifacts from the Maven repository
          provided by the Drools WB internals.
          - This file is deployed into jboss user home at $HOME/.m2/settings.xml
          - This file uses system environment variables to point to the Drools WB Docker container that provides the Maven repository. These variables are:
            KIE_MAVEN_REPO - Defaults to http://localhost:8080/drools-wb/maven2
            KIE_MAVEN_REPO_USER - Defaults to admin
            KIE_MAVEN_REPO_PASSWORD - Defaults to admin
      -->
      <settings>
        <localRepository>$${env.HOME}/.m2/repository</localRepository>

        <proxies>
        </proxies>

        <servers>
          <server>
            <id>kie-workbench</id>
            <username>$${env.KIE_MAVEN_REPO_USER}</username>
            <password>$${env.KIE_MAVEN_REPO_PASSWORD}</password>
            <configuration>
              <wagonProvider>httpclient</wagonProvider>
              <httpConfiguration>
                <all>
                  <usePreemptive>true</usePreemptive>
                </all>
              </httpConfiguration>
            </configuration>
          </server>
        </servers>

        <mirrors>
        </mirrors>

        <profiles>
          <profile>
            <id>kie</id>
            <properties>
            </properties>
            <repositories>
              <repository>
                <id>jboss-public-repository-group</id>
                <name>JBoss Public Maven Repository Group</name>
                <url>https://repository.jboss.org/nexus/content/groups/public-jboss/</url>
                <layout>default</layout>
                <releases>
                  <enabled>true</enabled>
                  <updatePolicy>never</updatePolicy>
                </releases>
                <snapshots>
                  <enabled>true</enabled>
                  <updatePolicy>always</updatePolicy>
                </snapshots>
              </repository>
              <repository>
                <id>kie-workbench</id>
                <name>JBoss BRMS Guvnor M2 Repository</name>
                <url>$${env.KIE_MAVEN_REPO}</url>
                <layout>default</layout>
                <releases>
                  <enabled>true</enabled>
                  <updatePolicy>always</updatePolicy>
                </releases>
                <snapshots>
                  <enabled>true</enabled>
                  <updatePolicy>always</updatePolicy>
                </snapshots>
              </repository>
            </repositories>
            <pluginRepositories>
              <pluginRepository>
                <id>jboss-public-repository-group</id>
                <name>JBoss Public Maven Repository Group</name>
                <url>https://repository.jboss.org/nexus/content/groups/public-jboss/</url>
                <layout>default</layout>
                <releases>
                  <enabled>true</enabled>
                  <updatePolicy>never</updatePolicy>
                </releases>
                <snapshots>
                  <enabled>true</enabled>
                  <updatePolicy>never</updatePolicy>
                </snapshots>
              </pluginRepository>
            </pluginRepositories>
          </profile>
        </profiles>

        <activeProfiles>
          <activeProfile>kie</activeProfile>
        </activeProfiles>

      </settings>
      EOF
  }
  metadata {
    name = var.name
    namespace = var.namespace
  }
}

locals {
  java_opts = join(" ", [
    "-server",
    "-Xms256m",
    "-Xmx1024m",
    "-Djava.net.preferIPv4Stack=true",
    "-Dfile.encoding=UTF-8",
    "-Dorg.kie.server.controller=${var.controller_url}",
    "-Dorg.kie.server.controller.user=${var.controller_user}",
    "-Dorg.kie.server.controller.pwd=${var.controller_pwd}",
    "-Dorg.kie.server.location=${var.kie_server_url}",
    "-Dorg.kie.server.user=${var.kie_server_user}",
    "-Dorg.kie.server.pwd=${var.kie_server_pwd}",
  ])

  parameters = {
    name = var.name
    namespace = var.namespace
    replicas = var.replicas
    ports = [
      {
        name = "http"
        port = "8080"
      },
    ]
    enable_service_links = false
    containers = [
      {
        name = "kie-server"
        image = var.image
        env = [
          {
            name = "JAVA_OPTS"
            value = local.java_opts
          },
          {
            name = "KIE_MAVEN_REPO"
            value = var.maven_repo_url
          },
          {
            name = "KIE_MAVEN_REPO_USER"
            value = var.maven_user
          },
          {
            name = "KIE_MAVEN_REPO_PASSWORD"
            value = var.maven_pwd
          },
        ]
        lifecycle = {
          post_start = {
            exec = {
              command = [
                "bash",
                "-cx",
                <<-EOF
                # maven repo
                mkdir -p /opt/jboss/.m2
                cp /tmp/settings.xml /opt/jboss/.m2/settings.xml

                # add user
                /opt/jboss/wildfly/bin/add-user.sh -u ${var.kie_server_user} -p ${var.kie_server_pwd} -ro admin,kie-server,rest-all -a

                until /opt/jboss/wildfly/bin/jboss-cli.sh -c --command="version"; do sleep 5; done

                # enable CORS
                /opt/jboss/wildfly/bin/jboss-cli.sh -c <<-JBOSS
                batch
                /subsystem=undertow/server=default-server/host=default-host/filter-ref=Access-Control-Allow-Origin:add
                /subsystem=undertow/server=default-server/host=default-host/filter-ref=Access-Control-Allow-Methods:add
                /subsystem=undertow/server=default-server/host=default-host/filter-ref=Access-Control-Allow-Headers:add
                /subsystem=undertow/server=default-server/host=default-host/filter-ref=Access-Control-Allow-Credentials:add
                /subsystem=undertow/server=default-server/host=default-host/filter-ref=Access-Control-Max-Age:add
                /subsystem=undertow/configuration=filter/response-header=Access-Control-Allow-Origin:add(header-name=Access-Control-Allow-Origin,header-value="*")
                /subsystem=undertow/configuration=filter/response-header=Access-Control-Allow-Methods:add(header-name=Access-Control-Allow-Methods,header-value="GET, POST, OPTIONS, PUT")
                /subsystem=undertow/configuration=filter/response-header=Access-Control-Allow-Headers:add(header-name=Access-Control-Allow-Headers,header-value="accept, authorization, content-type, x-requested-with")
                /subsystem=undertow/configuration=filter/response-header=Access-Control-Allow-Credentials:add(header-name=Access-Control-Allow-Credentials,header-value="true")
                /subsystem=undertow/configuration=filter/response-header=Access-Control-Max-Age:add(header-name=Access-Control-Max-Age,header-value="1")
                run-batch
                JBOSS

                /opt/jboss/wildfly/bin/jboss-cli.sh -c --command=":reload"
                EOF
              ]
            }
          }
        }
        volume_mounts = [
          {
            mount_path = "/tmp/settings.xml"
            name       = "config"
            sub_path   = "settings.xml"
          },
        ]
      }
    ]
    volumes = [
      {
        config_map = {
          name = k8s_core_v1_config_map.this.metadata[0].name
        }
        name = "config"
      },
    ]
  }
}

module "deployment-service" {
  source     = "git::https://github.com/mingfang/terraform-provider-k8s.git//archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
