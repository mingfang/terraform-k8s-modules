resource "k8s_core_v1_config_map" "context" {
  data = {
    "minifi-c2-context.xml" = <<-EOF
      <?xml version="1.0" encoding="UTF-8"?>
      <beans default-lazy-init="true"
             xmlns="http://www.springframework.org/schema/beans"
             xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans-3.1.xsd">

          <bean id="configService" class="org.apache.nifi.minifi.c2.service.ConfigService" scope="singleton">
              <constructor-arg>
                  <list>
                      <bean class="org.apache.nifi.minifi.c2.provider.nifi.rest.NiFiRestConfigurationProvider">
                          <constructor-arg>
                              <bean class="org.apache.nifi.minifi.c2.cache.filesystem.FileSystemConfigurationCache">
                                  <constructor-arg>
                                      <value>./cache</value>
                                  </constructor-arg>
                                  <constructor-arg>
                                      <value>$${class}/$${class}</value>
                                  </constructor-arg>
                              </bean>
                          </constructor-arg>
                          <constructor-arg>
                              <value>#{systemEnvironment['NIFI_REST_API_URL']}</value>
                          </constructor-arg>
                          <constructor-arg>
                              <value>$${class}.v$${version}</value>
                          </constructor-arg>
                      </bean>
                  </list>
              </constructor-arg>
              <constructor-arg>
                  <bean class="org.apache.nifi.minifi.c2.security.authorization.GrantedAuthorityAuthorizer">
                      <constructor-arg value="classpath:authorizations.yaml"/>
                  </bean>
              </constructor-arg>
          </bean>
      </beans>
      EOF
  }

  metadata {
    name      = "${var.name}-context"
    namespace = var.namespace
  }
}
