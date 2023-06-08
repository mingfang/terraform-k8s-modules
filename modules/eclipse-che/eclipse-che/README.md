
# Module `eclipse-che/eclipse-che`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `CHE_HOST` (required): For building the http and websocket URLs
* `CHE_INFRA_KUBERNETES_CLUSTER__ROLE__NAME` (default `null`): Extra permissions each workspace will get
* `CHE_INFRA_KUBERNETES_INGRESS_DOMAIN` (default `null`): domain suffix for each workspace ingress; Required when CHE_INFRA_KUBERNETES_SERVER__STRATEGY=multi-host
* `CHE_INFRA_KUBERNETES_INGRESS_PATH__TRANSFORM` (default `null`): set to %s(.*) when CHE_INFRA_KUBERNETES_SERVER__STRATEGY=single-host
* `CHE_INFRA_KUBERNETES_NAMESPACE_ANNOTATIONS__JSON` (default `null`)
* `CHE_INFRA_KUBERNETES_NAMESPACE_DEFAULT` (default `"che-\u003cusername\u003e"`): create new namespace for each user
* `CHE_INFRA_KUBERNETES_NAMESPACE_LABELS__JSON` (default `null`)
* `CHE_INFRA_KUBERNETES_NAMESPACE_LIMIT__RANGE__LIMIT__JSON` (default `null`)
* `CHE_INFRA_KUBERNETES_NAMESPACE_LIMIT__RANGE__REQUEST__JSON` (default `null`)
* `CHE_INFRA_KUBERNETES_NAMESPACE_RESOURCE__QUOTA__JSON` (default `null`)
* `CHE_INFRA_KUBERNETES_POD_SECURITY__CONTEXT_FS__GROUP` (default `"1724"`)
* `CHE_INFRA_KUBERNETES_POD_SECURITY__CONTEXT_RUN__AS__USER` (default `"1724"`)
* `CHE_INFRA_KUBERNETES_PVC_ACCESS__MODE` (default `"ReadWriteOnce"`)
* `CHE_INFRA_KUBERNETES_PVC_NAME` (default `"claim-che-workspace"`): name of pvc for each workspace
* `CHE_INFRA_KUBERNETES_PVC_QUANTITY` (default `"10Gi"`)
* `CHE_INFRA_KUBERNETES_PVC_STORAGE__CLASS__NAME` (default `"claim-che-workspace"`): storage class for each pvc in each workspace
* `CHE_INFRA_KUBERNETES_SERVER__STRATEGY` (default `"multi-host"`): default-host, multi-host, single-host
* `CHE_INFRA_KUBERNETES_SERVICE__ACCOUNT__NAME` (default `"che-workspace"`): name of auto created service account for each workspace
* `CHE_INFRA_KUBERNETES_TLS__CERT` (default `""`): base64 encoded cert coppied to each workspace to enable https for ingress
* `CHE_INFRA_KUBERNETES_TLS__ENABLED` (default `true`): Will use https and wss URLs if true
* `CHE_INFRA_KUBERNETES_TLS__KEY` (default `""`): base64 encoded key coppied to each workspace to enable https for ingress
* `CHE_KEYCLOAK_AUTH__SERVER__URL` (default `""`)
* `CHE_KEYCLOAK_CLIENT__ID` (default `""`)
* `CHE_KEYCLOAK_REALM` (default `""`)
* `CHE_LIMITS_USER_WORKSPACES_RUN_COUNT` (default `10`)
* `CHE_LIMITS_WORKSPACE_IDLE_TIMEOUT` (default `1800000`)
* `CHE_METRICS_ENABLED` (default `true`)
* `CHE_MULTIUSER` (default `true`): enable multi user support
* `CHE_OAUTH_GITHUB_CLIENTID` (default `""`)
* `CHE_OAUTH_GITHUB_CLIENTSECRET` (default `""`)
* `CHE_SYSTEM_ADMIN__NAME` (default `"admin"`): Grant system permission for 'che.admin.name' user. If the user already exists it’ll happen oncomponent startup, if not - during the first login when user is persisted in the database.
* `CHE_WORKSPACE_DEVFILE__REGISTRY__URL` (required)
* `CHE_WORKSPACE_PLUGIN__REGISTRY__URL` (required)
* `CHE_WORKSPACE_SIDECAR_DEFAULT__MEMORY__LIMIT__MB` (default `256`)
* `JAEGER_ENDPOINT` (default `null`)
* `JAVA_OPTS` (default `"-XX:MaxRAMPercentage=85.0 "`)
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"quay.io/eclipse/che-server:7.50.0"`)
* `ingress_class` (required)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":8080},{"name":"metrics","port":8087}]`)
* `replicas` (default `1`)

## Output Values
* `deployment`
* `name`
* `service`

## Managed Resources
* `k8s_core_v1_config_map.che` from `k8s`
* `k8s_core_v1_service_account.che` from `k8s`
* `k8s_rbac_authorization_k8s_io_v1_cluster_role_binding.default_che_clusterrole_binding` from `k8s`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)

