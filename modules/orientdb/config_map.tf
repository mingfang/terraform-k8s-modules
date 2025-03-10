resource "k8s_core_v1_config_map" "this" {
  data = {
    "hazelcast.xml" = <<-EOF
      <?xml version="1.0" encoding="UTF-8"?>
      <hazelcast
              xsi:schemaLocation="http://www.hazelcast.com/schema/config hazelcast-config-3.3.xsd"
              xmlns="http://www.hazelcast.com/schema/config" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
          <group>
              <name>orientdb</name>
              <password>orientdb</password>
          </group>
          <properties>
              <property name="hazelcast.phone.home.enabled">false</property>
              <property name="hazelcast.mancenter.enabled">false</property>
              <property name="hazelcast.memcache.enabled">false</property>
              <property name="hazelcast.rest.enabled">false</property>
              <property name="hazelcast.wait.seconds.before.join">5</property>
              <property name="hazelcast.operation.thread.count">1</property>
              <property name="hazelcast.io.thread.count">1</property>
              <property name="hazelcast.operation.generic.thread.count">1</property>
              <property name="hazelcast.client.event.thread.count">1</property>
              <property name="hazelcast.event.thread.count">1</property>
              <property name="hazelcast.heartbeat.interval.seconds">5</property>
              <property name="hazelcast.max.no.heartbeat.seconds">30</property>
              <property name="hazelcast.merge.next.run.delay.seconds">15</property>
          </properties>
          <network>
              <port auto-increment="true">2434</port>
              <join>
                  <multicast enabled="false">
                      <multicast-group>235.1.1.1</multicast-group>
                      <multicast-port>2434</multicast-port>
                  </multicast>
                  <tcp-ip enabled="true">
                    ${join(" ", data.template_file.members.*.rendered)}
                  </tcp-ip>
              </join>
          </network>
          <executor-service>
              <pool-size>16</pool-size>
          </executor-service>
        </hazelcast>
      EOF
  }
  metadata {
    name      = var.name
    namespace = var.namespace
  }
}

data "template_file" "members" {
  count    = var.replicas
  template = "<member>${var.name}-${count.index}.${var.name}.${var.namespace}</member>"
}