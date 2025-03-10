resource "k8s_core_v1_config_map" "this" {
  metadata {
    name      = var.name
    namespace = var.namespace
  }

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
}
