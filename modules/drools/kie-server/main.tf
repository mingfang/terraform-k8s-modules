locals {
  parameters = {
    name      = var.name
    namespace = var.namespace
    replicas  = var.replicas
    ports = [
      {
        name = "http"
        port = "8080"
      },
    ]
    enable_service_links = false
    containers = [
      {
        name  = "kie-server"
        image = var.image
        env = [
          {
            name = "POD_NAME"

            value_from = {
              field_ref = {
                field_path = "metadata.name"
              }
            }
          },
          {
            name  = "JAVA_OPTS"
            value = join(" ", [
              "-server",
              "-Xms256m",
              "-Xmx1024m",
              "-Djava.net.preferIPv4Stack=true",
              "-Dfile.encoding=UTF-8",
              "-Dorg.kie.server.controller=${var.controller_url}",
              "-Dorg.kie.server.controller.user=${var.controller_user}",
              "-Dorg.kie.server.controller.pwd=${var.controller_pwd}",
              "-Dorg.kie.server.location=http://$(POD_NAME):8080/kie-server/services/rest/server",
              "-Dorg.kie.server.id=${var.kie_server_id}",
              "-Dorg.kie.server.user=${var.kie_server_user}",
              "-Dorg.kie.server.pwd=${var.kie_server_pwd}",
            ])
          },
          {
            name  = "KIE_MAVEN_REPO"
            value = var.maven_repo_url
          },
          {
            name  = "KIE_MAVEN_REPO_USER"
            value = var.maven_user
          },
          {
            name  = "KIE_MAVEN_REPO_PASSWORD"
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
  source     = "git::https://github.com/mingfang/terraform-k8s-modules.git//archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
