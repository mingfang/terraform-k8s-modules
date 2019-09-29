resource "k8s_core_v1_config_map" "this" {
  data = {
    "values.yaml" = <<-EOF
      Chart:
        Name: jupyterhub
        Version: 0.9-36ff743
      Release:
        Name: release-name
        Namespace: ${var.namespace}
        Service: Tiller
      auth:
        admin:
          access: true
          users: null
        dummy:
          password: null
        ldap:
          dn:
            search: {}
            user: {}
          user: {}
        state:
          enabled: false
        type: dummy
        whitelist:
          users: null
      cull:
        concurrency: 10
        enabled: true
        every: 600
        maxAge: 0
        timeout: 3600
        users: false
      custom: {}
      debug:
        enabled: false
      hub:
        activeServerLimit: null
        allowNamedServers: false
        annotations: {}
        baseUrl: /
        concurrentSpawnLimit: 64
        consecutiveFailureLimit: 5
        db:
          password: null
          pvc:
            accessModes:
            - ReadWriteOnce
            annotations: {}
            selector: {}
            storage: 1Gi
            storageClassName: null
            subPath: null
          type: sqlite
          upgrade: null
          url: null
        deploymentStrategy:
          rollingUpdate: null
          type: Recreate
        extraConfig: ${jsonencode(merge({jupyterlab="c.Spawner.cmd = ['jupyter-labhub']"}, var.hub_extraConfig))}
        extraContainers: []
        extraVolumeMounts: []
        extraVolumes: []
        fsGid: 1000
        image:
          name: jupyterhub/k8s-hub
          tag: 0.9-36ff743
        imagePullPolicy: IfNotPresent
        imagePullSecret:
          email: null
          enabled: false
          password: null
          registry: null
          username: null
        labels: {}
        networkPolicy:
          egress:
          - to:
            - ipBlock:
                cidr: 0.0.0.0/0
          enabled: false
        nodeSelector: {}
        pdb:
          enabled: true
          minAvailable: 1
        publicURL: null
        resources:
          requests:
            cpu: 200m
            memory: 512Mi
        service:
          annotations: {}
          loadBalancerIP: null
          ports:
            nodePort: null
          type: ClusterIP
        services: {}
        uid: 1000
      scheduling:
        corePods:
          nodeAffinity:
            matchNodePurpose: prefer
        podPriority:
          defaultPriority: 0
          enabled: false
          globalDefault: false
          userPlaceholderPriority: -10
        userPlaceholder:
          enabled: false
          replicas: 0
        userPods:
          nodeAffinity:
            matchNodePurpose: prefer
        userScheduler:
          enabled: false
          image:
            name: gcr.io/google_containers/kube-scheduler-amd64
            tag: v1.11.2
          logLevel: 4
          nodeSelector: {}
          pdb:
            enabled: true
            minAvailable: 1
          replicas: 1
          resources:
            requests:
              cpu: 50m
              memory: 256Mi
      singleuser:
        cloudMetadata:
          enabled: false
          ip: 169.254.169.254
        cmd: jupyterhub-singleuser
        cpu:
          guarantee: null
          limit: null
        defaultUrl: /lab
        events: true
        extraAnnotations: {}
        extraContainers: []
        extraEnv: ${jsonencode(var.singleuser_extraEnv)}
        extraLabels:
          hub.jupyter.org/network-access-hub: "true"
        extraNodeAffinity:
          preferred: []
          required: []
        extraPodAffinity:
          preferred: []
          required: []
        extraPodAntiAffinity:
          preferred: []
          required: []
        extraResource:
          guarantees: {}
          limits: {}
        extraTolerations: []
        fsGid: 100
        image:
          name: ${var.singleuser_image_name}
          pullPolicy: IfNotPresent
          tag: ${var.singleuser_image_tag}
        imagePullSecret:
          email: null
          enabled: false
          registry: null
          username: null
        initContainers: []
        lifecycleHooks: null
        memory:
          guarantee: 1G
          limit: null
        networkPolicy:
          egress:
          - to:
            - ipBlock:
                cidr: 0.0.0.0/0
                except:
                - 169.254.169.254/32
          enabled: false
        networkTools:
          image:
            name: jupyterhub/k8s-network-tools
            tag: 0.9-b51ffeb
        nodeSelector: {}
        profileList: ${jsonencode(var.singleuser_profile_list)}
        serviceAccountName: null
        startTimeout: 300
        storage:
          capacity: 10Gi
          dynamic:
            pvcNameTemplate: claim-{username}{servername}
            storageAccessModes:
            - ReadWriteOnce
            storageClass: null
            volumeNameTemplate: volume-{username}{servername}
          extraLabels: {}
          extraVolumeMounts: ${jsonencode(var.singleuser_storage_extra_volume_mounts)}
          extraVolumes: ${jsonencode(var.singleuser_storage_extra_volumes)}
          homeMountPath: /home/jovyan
          static:
            pvcName: ${var.singleuser_storage_static_pvcName}
            subPath: '{username}'
          type: static
        uid: 1000

      EOF
  }
  metadata {
    name = var.name
    namespace = var.namespace
  }
}