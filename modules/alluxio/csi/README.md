
# Module `alluxio/csi`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `args` (default `["--v=5","--nodeid=$(NODE_ID)","--endpoint=$(CSI_ENDPOINT)"]`)
* `command` (default `["/usr/local/bin/alluxio-csi"]`)
* `domain_socket_path` (default `null`)
* `image` (default `"registry.rebelsoft.com/alluxio-csi"`)
* `name` (required)
* `namespace` (default `null`)

## Output Values
* `_provisioner`

## Child Modules
* `attacher` from [../../kubernetes/csi/attacher](../../kubernetes/csi/attacher)
* `nodeplugin` from [../../kubernetes/csi/nodeplugin](../../kubernetes/csi/nodeplugin)
* `provisioner` from [../../kubernetes/csi/provisioner](../../kubernetes/csi/provisioner)

