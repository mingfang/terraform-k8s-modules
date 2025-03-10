
# Module `kiwigrid/k8s-sidecar`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `DEFAULT_FILE_MODE` (default `null`): The default file system permission for every file. Use three digits (e.g. '500', '440', ...)
* `ERROR_THROTTLE_SLEEP` (default `5`): How many seconds to wait before watching resources again when an error occurs
* `FOLDER_ANNOTATION` (default `"k8s-sidecar-target-directory"`): The annotation the sidecar will look for in configmaps to override the destination folder for files, defaults to "k8s-sidecar-target-directory"
* `LABEL` (required): Label that should be used for filtering
* `LABEL_VALUE` (default `null`): The value for the label you want to filter your resources on. Don't set a value to filter by any value
* `METHOD` (default `null`): If METHOD is set with LIST, the sidecar will just list config-maps/secrets and exit. With SLEEP it will list all config-maps/secrets, then sleep for SLEEP_TIME seconds. Default is watch.
* `NAMESPACE` (default `null`): If specified, the sidecar will search for config-maps inside this namespace. Otherwise the namespace in which the sidecar is running will be used. It's also possible to specify ALL to search in all namespaces.
* `REQ_METHOD` (default `null`): Request method GET(default) or POST
* `REQ_PASSWORD` (default `null`): Password to use for basic authentication
* `REQ_PAYLOAD` (default `null`): If you use POST you can also provide json payload
* `REQ_RETRY_BACKOFF_FACTOR` (default `0.2`): A backoff factor to apply between attempts after the second try
* `REQ_RETRY_CONNECT` (default `5`): How many connection-related errors to retry on
* `REQ_RETRY_READ` (default `5`): How many times to retry on read errors
* `REQ_RETRY_TOTAL` (default `5`): Total number of retries to allow
* `REQ_TIMEOUT` (default `10`): How many seconds to wait for the server to send data before giving up
* `REQ_URL` (default `null`): URL to which send a request after a configmap/secret got reloaded
* `REQ_USERNAME` (default `null`): Username to use for basic authentication
* `RESOURCE` (default `"configmap"`): Resource type, which is monitored by the sidecar. Options: configmap (default), secret, both
* `SCRIPT` (default `null`): Absolute path to shell script to execute after a configmap got reloaded. In runs before REQ
* `SKIP_TLS_VERIFY` (default `null`): Set to true to skip tls verification for kube api calls
* `SLEEP_TIME` (default `60`): How many seconds to wait before updating config-maps/secrets when using SLEEP method.
* `UNIQUE_FILENAMES` (default `null`): Set to true to produce unique filenames where duplicate data keys exist between ConfigMaps and/or Secrets within the same or multiple Namespaces.
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"kiwigrid/k8s-sidecar:latest"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `pvc_name` (default `null`)
* `resources` (default `{"requests":{"cpu":"100m","memory":"10Mi"}}`)

## Output Values
* `deployment`
* `name`
* `service`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)
* `rbac` from [../../../modules/kubernetes/rbac](../../../modules/kubernetes/rbac)

