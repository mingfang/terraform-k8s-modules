
# Module `kubernetes/ingress-nginx`

Provider Requirements:
* **k8s (`mingfang/k8s`):** (any version)

## Input Variables
* `config_map_data` (default `{}`)
* `container_ports` (default `null`)
* `external_traffic_policy` (default `"Cluster"`): set to null if service_type is not LoadBalancer
* `extra_args` (default `[]`)
* `ingress_class` (default `"nginx"`)
* `load_balancer_ip` (default `null`)
* `name` (required)
* `namespace` (default `"default"`)
* `node_selector` (default `{}`): key/value pair. e.g. zone=com
* `ports` (default `[{"name":"http","port":80,"protocol":"TCP","target_port":"80"},{"name":"https","port":443,"protocol":"TCP","target_port":"443"}]`)
* `replicas` (default `1`)
* `service_type` (default `"LoadBalancer"`)
* `tcp_services_data` (default `{}`)
* `udp_services_data` (default `{}`)

## Output Values
* `deployment`
* `ingress_class`
* `service`

## Managed Resources
* `k8s_apps_v1_deployment.nginx_ingress_controller` from `k8s`
* `k8s_core_v1_config_map.nginx_configuration` from `k8s`
* `k8s_core_v1_config_map.tcp_services` from `k8s`
* `k8s_core_v1_config_map.udp_services` from `k8s`
* `k8s_core_v1_service.ingress_nginx` from `k8s`
* `k8s_core_v1_service_account.nginx_ingress_serviceaccount` from `k8s`
* `k8s_rbac_authorization_k8s_io_v1beta1_cluster_role.nginx_ingress_clusterrole` from `k8s`
* `k8s_rbac_authorization_k8s_io_v1beta1_cluster_role_binding.nginx_ingress_clusterrole_nisa_binding` from `k8s`
* `k8s_rbac_authorization_k8s_io_v1beta1_role.nginx_ingress_role` from `k8s`
* `k8s_rbac_authorization_k8s_io_v1beta1_role_binding.nginx_ingress_role_nisa_binding` from `k8s`

