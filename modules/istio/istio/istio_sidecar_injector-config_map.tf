resource "k8s_core_v1_config_map" "istio_sidecar_injector" {
  data = {
    "config" = <<-EOF
      policy: enabled
      alwaysInjectSelector:
        []
      neverInjectSelector:
        []
      template: |-
        rewriteAppHTTPProbe: {{ valueOrDefault .Values.sidecarInjectorWebhook.rewriteAppHTTPProbe true }}
        initContainers:
        {{ if ne (annotation .ObjectMeta `sidecar.istio.io/interceptionMode` .ProxyConfig.InterceptionMode) `NONE` }}
        {{ if .Values.istio_cni.enabled -}}
        - name: istio-validation
        {{ else -}}
        - name: istio-init
        {{ end -}}
        {{- if contains "/" .Values.global.proxy_init.image }}
          image: "{{ .Values.global.proxy_init.image }}"
        {{- else }}
          image: "{{ .Values.global.hub }}/{{ .Values.global.proxy_init.image }}:{{ .Values.global.tag }}"
        {{- end }}
          command:
          - istio-iptables
          - "-p"
          - "15001"
          - "-z"
          - "15006"
          - "-u"
          - 1337
          - "-m"
          - "{{ annotation .ObjectMeta `sidecar.istio.io/interceptionMode` .ProxyConfig.InterceptionMode }}"
          - "-i"
          - "{{ annotation .ObjectMeta `traffic.sidecar.istio.io/includeOutboundIPRanges` .Values.global.proxy.includeIPRanges }}"
          - "-x"
          - "{{ annotation .ObjectMeta `traffic.sidecar.istio.io/excludeOutboundIPRanges` .Values.global.proxy.excludeIPRanges }}"
          - "-b"
          - "{{ annotation .ObjectMeta `traffic.sidecar.istio.io/includeInboundPorts` `*` }}"
          - "-d"
          - "{{ excludeInboundPort (annotation .ObjectMeta `status.sidecar.istio.io/port` .Values.global.proxy.statusPort) (annotation .ObjectMeta `traffic.sidecar.istio.io/excludeInboundPorts` .Values.global.proxy.excludeInboundPorts) }}"
          {{ if or (isset .ObjectMeta.Annotations `traffic.sidecar.istio.io/excludeOutboundPorts`) (ne (valueOrDefault .Values.global.proxy.excludeOutboundPorts "") "") -}}
          - "-o"
          - "{{ annotation .ObjectMeta `traffic.sidecar.istio.io/excludeOutboundPorts` .Values.global.proxy.excludeOutboundPorts }}"
          {{ end -}}
          {{ if (isset .ObjectMeta.Annotations `traffic.sidecar.istio.io/kubevirtInterfaces`) -}}
          - "-k"
          - "{{ index .ObjectMeta.Annotations `traffic.sidecar.istio.io/kubevirtInterfaces` }}"
          {{ end -}}
          {{ if .Values.istio_cni.enabled -}}
          - "--run-validation"
          - "--skip-rule-apply"
          {{ end -}}
          imagePullPolicy: "{{ valueOrDefault .Values.global.imagePullPolicy `Always` }}"
        {{- if .Values.global.proxy_init.resources }}
          resources:
            {{ toYaml .Values.global.proxy_init.resources | indent 4 }}
        {{- else }}
          resources: {}
        {{- end }}
          securityContext:
            allowPrivilegeEscalation: {{ .Values.global.proxy.privileged }}
            privileged: {{ .Values.global.proxy.privileged }}
            capabilities:
          {{- if not .Values.istio_cni.enabled }}
              add:
              - NET_ADMIN
              - NET_RAW
          {{- end }}
              drop:
              - ALL
          {{- if not .Values.istio_cni.enabled }}
            readOnlyRootFilesystem: false
            runAsGroup: 0
            runAsNonRoot: false
            runAsUser: 0
          {{- else }}
            readOnlyRootFilesystem: true
            runAsGroup: 1337
            runAsUser: 1337
            runAsNonRoot: true
          {{- end }}
          restartPolicy: Always
        {{  end -}}
        {{- if eq (annotation .ObjectMeta `sidecar.istio.io/enableCoreDump` .Values.global.proxy.enableCoreDump) "true" }}
        - name: enable-core-dump
          args:
          - -c
          - sysctl -w kernel.core_pattern=/var/lib/istio/core.proxy && ulimit -c unlimited
          command:
            - /bin/sh
          image: {{ $.Values.global.proxy.enableCoreDumpImage }}
          imagePullPolicy: IfNotPresent
          resources: {}
          securityContext:
            allowPrivilegeEscalation: true
            capabilities:
              add:
              - SYS_ADMIN
              drop:
              - ALL
            privileged: true
            readOnlyRootFilesystem: false
            runAsGroup: 0
            runAsNonRoot: false
            runAsUser: 0
        {{ end }}
        containers:
        - name: istio-proxy
        {{- if contains "/" (annotation .ObjectMeta `sidecar.istio.io/proxyImage` .Values.global.proxy.image) }}
          image: "{{ annotation .ObjectMeta `sidecar.istio.io/proxyImage` .Values.global.proxy.image }}"
        {{- else }}
          image: "{{ annotation .ObjectMeta `sidecar.istio.io/proxyImage` .Values.global.hub }}/{{ .Values.global.proxy.image }}:{{ .Values.global.tag }}"
        {{- end }}
          ports:
          - containerPort: 15090
            protocol: TCP
            name: http-envoy-prom
          args:
          - proxy
          - sidecar
          - --domain
          - $(POD_NAMESPACE).svc.{{ .Values.global.proxy.clusterDomain }}
          - --configPath
          - "{{ .ProxyConfig.ConfigPath }}"
          - --binaryPath
          - "{{ .ProxyConfig.BinaryPath }}"
          - --serviceCluster
          {{ if ne "" (index .ObjectMeta.Labels "app") -}}
          - "{{ index .ObjectMeta.Labels `app` }}.$(POD_NAMESPACE)"
          {{ else -}}
          - "{{ valueOrDefault .DeploymentMeta.Name `istio-proxy` }}.{{ valueOrDefault .DeploymentMeta.Namespace `default` }}"
          {{ end -}}
          - --drainDuration
          - "{{ formatDuration .ProxyConfig.DrainDuration }}"
          - --parentShutdownDuration
          - "{{ formatDuration .ProxyConfig.ParentShutdownDuration }}"
          - --discoveryAddress
          - "{{ annotation .ObjectMeta `sidecar.istio.io/discoveryAddress` .ProxyConfig.DiscoveryAddress }}"
        {{- if eq .Values.global.proxy.tracer "lightstep" }}
          - --lightstepAddress
          - "{{ .ProxyConfig.GetTracing.GetLightstep.GetAddress }}"
          - --lightstepAccessToken
          - "{{ .ProxyConfig.GetTracing.GetLightstep.GetAccessToken }}"
          - --lightstepSecure={{ .ProxyConfig.GetTracing.GetLightstep.GetSecure }}
        {{- if .ProxyConfig.GetTracing.GetLightstep.GetSecure }}
          - --lightstepCacertPath
          - "{{ .ProxyConfig.GetTracing.GetLightstep.GetCacertPath }}"
        {{- end }}
        {{- else if eq .Values.global.proxy.tracer "zipkin" }}
          - --zipkinAddress
          - "{{ .ProxyConfig.GetTracing.GetZipkin.GetAddress }}"
        {{- else if eq .Values.global.proxy.tracer "datadog" }}
          - --datadogAgentAddress
          - "{{ .ProxyConfig.GetTracing.GetDatadog.GetAddress }}"
        {{- end }}
        {{- if .Values.global.proxy.logLevel }}
          - --proxyLogLevel={{ .Values.global.proxy.logLevel }}
        {{- end}}
        {{- if .Values.global.proxy.componentLogLevel }}
          - --proxyComponentLogLevel={{ .Values.global.proxy.componentLogLevel }}
        {{- end}}
        {{- if .Values.global.proxy.outlierLogPath }}
          - --outlierLogPath={{ .Values.global.proxy.outlierLogPath }}
        {{- end}}
          - --dnsRefreshRate
          - {{ .Values.global.proxy.dnsRefreshRate }}
          - --connectTimeout
          - "{{ formatDuration .ProxyConfig.ConnectTimeout }}"
        {{- if .Values.global.proxy.envoyStatsd.enabled }}
          - --statsdUdpAddress
          - "{{ .ProxyConfig.StatsdUdpAddress }}"
        {{- end }}
        {{- if .Values.global.proxy.envoyMetricsService.enabled }}
          - --envoyMetricsService
          - '{{ protoToJSON .ProxyConfig.EnvoyMetricsService }}'
        {{- end }}
        {{- if .Values.global.proxy.envoyAccessLogService.enabled }}
          - --envoyAccessLogService
          - '{{ protoToJSON .ProxyConfig.EnvoyAccessLogService }}'
        {{- end }}
          - --proxyAdminPort
          - "{{ .ProxyConfig.ProxyAdminPort }}"
          {{ if gt .ProxyConfig.Concurrency 0 -}}
          - --concurrency
          - "{{ .ProxyConfig.Concurrency }}"
          {{ end -}}
          - --controlPlaneAuthPolicy
          - "{{ annotation .ObjectMeta `sidecar.istio.io/controlPlaneAuthPolicy` .ProxyConfig.ControlPlaneAuthPolicy }}"
        {{- if (ne (annotation .ObjectMeta "status.sidecar.istio.io/port" (valueOrDefault .Values.global.proxy.statusPort 0 )) `0`) }}
          - --statusPort
          - "{{ annotation .ObjectMeta `status.sidecar.istio.io/port` .Values.global.proxy.statusPort }}"
        {{- end }}
        {{- if .Values.global.trustDomain }}
          - --trust-domain={{ .Values.global.trustDomain }}
        {{- end }}
        {{- if .Values.global.proxy.lifecycle }}
          lifecycle:
            {{ toYaml .Values.global.proxy.lifecycle | indent 4 }}
        {{- end }}
          env:
          - name: POD_NAME
            valueFrom:
              fieldRef:
                fieldPath: metadata.name
          - name: ISTIO_META_POD_PORTS
            value: |-
              [
              {{- $first := true }}
              {{- range $index1, $c := .Spec.Containers }}
                {{- range $index2, $p := $c.Ports }}
                  {{- if (structToJSON $p) }}
                  {{if not $first}},{{end}}{{ structToJSON $p }}
                  {{- $first = false }}
                  {{- end }}
                {{- end}}
              {{- end}}
              ]
          - name: ISTIO_META_APP_CONTAINERS
            value: |-
              [
                {{- range $index, $container := .Spec.Containers }}
                  {{- if ne $index 0}},{{- end}}
                  {{ $container.Name }}
                {{- end}}
              ]
          - name: ISTIO_META_CLUSTER_ID
            value: "{{ valueOrDefault .Values.global.multiCluster.clusterName `Kubernetes` }}"
          - name: POD_NAMESPACE
            valueFrom:
              fieldRef:
                fieldPath: metadata.namespace
          - name: INSTANCE_IP
            valueFrom:
              fieldRef:
                fieldPath: status.podIP
          - name: SERVICE_ACCOUNT
            valueFrom:
              fieldRef:
                fieldPath: spec.serviceAccountName
          {{- if .Values.global.mtls.auto }}
          - name: ISTIO_AUTO_MTLS_ENABLED
            value: "true"
          {{- end }}
        {{- if eq .Values.global.proxy.tracer "datadog" }}
          - name: HOST_IP
            valueFrom:
              fieldRef:
                fieldPath: status.hostIP
        {{- if isset .ObjectMeta.Annotations `apm.datadoghq.com/env` }}
        {{- range $key, $value := fromJSON (index .ObjectMeta.Annotations `apm.datadoghq.com/env`) }}
          - name: {{ $key }}
            value: "{{ $value }}"
        {{- end }}
        {{- end }}
        {{- end }}
          - name: ISTIO_META_POD_NAME
            valueFrom:
              fieldRef:
                fieldPath: metadata.name
          - name: ISTIO_META_CONFIG_NAMESPACE
            valueFrom:
              fieldRef:
                fieldPath: metadata.namespace
          - name: SDS_ENABLED
            value: {{ $.Values.global.sds.enabled }}
          - name: ISTIO_META_INTERCEPTION_MODE
            value: "{{ or (index .ObjectMeta.Annotations `sidecar.istio.io/interceptionMode`) .ProxyConfig.InterceptionMode.String }}"
          {{- if .Values.global.network }}
          - name: ISTIO_META_NETWORK
            value: "{{ .Values.global.network }}"
          {{- end }}
          {{ if .ObjectMeta.Annotations }}
          - name: ISTIO_METAJSON_ANNOTATIONS
            value: |
                   {{ toJSON .ObjectMeta.Annotations }}
          {{ end }}
          {{ if .ObjectMeta.Labels }}
          - name: ISTIO_METAJSON_LABELS
            value: |
                   {{ toJSON .ObjectMeta.Labels }}
          {{ end }}
          {{- if .DeploymentMeta.Name }}
          - name: ISTIO_META_WORKLOAD_NAME
            value: {{ .DeploymentMeta.Name }}
          {{ end }}
          {{- if and .TypeMeta.APIVersion .DeploymentMeta.Name }}
          - name: ISTIO_META_OWNER
            value: kubernetes://apis/{{ .TypeMeta.APIVersion }}/namespaces/{{ valueOrDefault .DeploymentMeta.Namespace `default` }}/{{ toLower .TypeMeta.Kind}}s/{{ .DeploymentMeta.Name }}
           {{- end}}
          {{- if (isset .ObjectMeta.Annotations `sidecar.istio.io/bootstrapOverride`) }}
          - name: ISTIO_BOOTSTRAP_OVERRIDE
            value: "/etc/istio/custom-bootstrap/custom_bootstrap.json"
          {{- end }}
          {{- if .Values.global.sds.customTokenDirectory }}
          - name: ISTIO_META_SDS_TOKEN_PATH
            value: "{{ .Values.global.sds.customTokenDirectory -}}/sdstoken"
          {{- end }}
          {{- if .Values.global.meshID }}
          - name: ISTIO_META_MESH_ID
            value: "{{ .Values.global.meshID }}"
          {{- else if .Values.global.trustDomain }}
          - name: ISTIO_META_MESH_ID
            value: "{{ .Values.global.trustDomain }}"
          {{- end }}
          {{- if eq .Values.global.proxy.tracer "stackdriver" }}
          - name: STACKDRIVER_TRACING_ENABLED
            value: "true"
          - name: STACKDRIVER_TRACING_DEBUG
            value: "{{ .ProxyConfig.GetTracing.GetStackdriver.GetDebug }}"
          {{- if .ProxyConfig.GetTracing.GetStackdriver.GetMaxNumberOfAnnotations }}
          - name: STACKDRIVER_TRACING_MAX_NUMBER_OF_ANNOTATIONS
            value: "{{ .ProxyConfig.GetTracing.GetStackdriver.GetMaxNumberOfAnnotations.Value }}"
          {{- end }}
          {{- if .ProxyConfig.GetTracing.GetStackdriver.GetMaxNumberOfAttributes }}
          - name: STACKDRIVER_TRACING_MAX_NUMBER_OF_ATTRIBUTES
            value: "{{ .ProxyConfig.GetTracing.GetStackdriver.GetMaxNumberOfAttributes.Value }}"
          {{- end }}
          {{- if .ProxyConfig.GetTracing.GetStackdriver.GetMaxNumberOfMessageEvents }}
          - name: STACKDRIVER_TRACING_MAX_NUMBER_OF_MESSAGE_EVENTS
            value: "{{ .ProxyConfig.GetTracing.GetStackdriver.GetMaxNumberOfMessageEvents.Value }}"
          {{- end }}
          {{- end }}
          imagePullPolicy: {{ .Values.global.imagePullPolicy }}
          {{ if ne (annotation .ObjectMeta `status.sidecar.istio.io/port` (valueOrDefault .Values.global.proxy.statusPort 0 )) `0` }}
          readinessProbe:
            httpGet:
              path: /healthz/ready
              port: {{ annotation .ObjectMeta `status.sidecar.istio.io/port` .Values.global.proxy.statusPort }}
            initialDelaySeconds: {{ annotation .ObjectMeta `readiness.status.sidecar.istio.io/initialDelaySeconds` .Values.global.proxy.readinessInitialDelaySeconds }}
            periodSeconds: {{ annotation .ObjectMeta `readiness.status.sidecar.istio.io/periodSeconds` .Values.global.proxy.readinessPeriodSeconds }}
            failureThreshold: {{ annotation .ObjectMeta `readiness.status.sidecar.istio.io/failureThreshold` .Values.global.proxy.readinessFailureThreshold }}
          {{ end -}}
          securityContext:
            allowPrivilegeEscalation: {{ .Values.global.proxy.privileged }}
            capabilities:
              {{ if eq (annotation .ObjectMeta `sidecar.istio.io/interceptionMode` .ProxyConfig.InterceptionMode) `TPROXY` -}}
              add:
              - NET_ADMIN
              {{- end }}
              drop:
              - ALL
            privileged: {{ .Values.global.proxy.privileged }}
            readOnlyRootFilesystem: {{ ne (annotation .ObjectMeta `sidecar.istio.io/enableCoreDump` .Values.global.proxy.enableCoreDump) "true" }}
            runAsGroup: 1337
            {{ if eq (annotation .ObjectMeta `sidecar.istio.io/interceptionMode` .ProxyConfig.InterceptionMode) `TPROXY` -}}
            runAsNonRoot: false
            runAsUser: 0
            {{- else -}}
            runAsNonRoot: true
            runAsUser: 1337
            {{- end }}
          resources:
            {{ if or (isset .ObjectMeta.Annotations `sidecar.istio.io/proxyCPU`) (isset .ObjectMeta.Annotations `sidecar.istio.io/proxyMemory`) -}}
            requests:
              {{ if (isset .ObjectMeta.Annotations `sidecar.istio.io/proxyCPU`) -}}
              cpu: "{{ index .ObjectMeta.Annotations `sidecar.istio.io/proxyCPU` }}"
              {{ end}}
              {{ if (isset .ObjectMeta.Annotations `sidecar.istio.io/proxyMemory`) -}}
              memory: "{{ index .ObjectMeta.Annotations `sidecar.istio.io/proxyMemory` }}"
              {{ end }}
          {{ else -}}
        {{- if .Values.global.proxy.resources }}
            {{ toYaml .Values.global.proxy.resources | indent 4 }}
        {{- end }}
          {{  end -}}
          volumeMounts:
          {{ if (isset .ObjectMeta.Annotations `sidecar.istio.io/bootstrapOverride`) }}
          - mountPath: /etc/istio/custom-bootstrap
            name: custom-bootstrap-volume
          {{- end }}
          - mountPath: /etc/istio/proxy
            name: istio-envoy
          {{- if .Values.global.sds.enabled }}
          - mountPath: /var/run/sds
            name: sds-uds-path
            readOnly: true
          - mountPath: /var/run/secrets/tokens
            name: istio-token
          {{- if .Values.global.sds.customTokenDirectory }}
          - mountPath: "{{ .Values.global.sds.customTokenDirectory -}}"
            name: custom-sds-token
            readOnly: true
          {{- end }}
          {{- else }}
          - mountPath: /etc/certs/
            name: istio-certs
            readOnly: true
          {{- end }}
          {{- if and (eq .Values.global.proxy.tracer "lightstep") .Values.global.tracer.lightstep.cacertPath }}
          - mountPath: {{ directory .ProxyConfig.GetTracing.GetLightstep.GetCacertPath }}
            name: lightstep-certs
            readOnly: true
          {{- end }}
            {{- if isset .ObjectMeta.Annotations `sidecar.istio.io/userVolumeMount` }}
            {{ range $index, $value := fromJSON (index .ObjectMeta.Annotations `sidecar.istio.io/userVolumeMount`) }}
          - name: "{{  $index }}"
            {{ toYaml $value | indent 4 }}
            {{ end }}
            {{- end }}
        volumes:
        {{- if (isset .ObjectMeta.Annotations `sidecar.istio.io/bootstrapOverride`) }}
        - name: custom-bootstrap-volume
          configMap:
            name: {{ annotation .ObjectMeta `sidecar.istio.io/bootstrapOverride` "" }}
        {{- end }}
        - emptyDir:
            medium: Memory
          name: istio-envoy
        {{- if .Values.global.sds.enabled }}
        - name: sds-uds-path
          hostPath:
            path: /var/run/sds
        - name: istio-token
          projected:
            sources:
              - serviceAccountToken:
                  path: istio-token
                  expirationSeconds: 43200
                  audience: {{ .Values.global.sds.token.aud }}
        {{- if .Values.global.sds.customTokenDirectory }}
        - name: custom-sds-token
          secret:
            secretName: sdstokensecret
        {{- end }}
        {{- else }}
        - name: istio-certs
          secret:
            optional: true
            {{ if eq .Spec.ServiceAccountName "" }}
            secretName: istio.default
            {{ else -}}
            secretName: {{  printf "istio.%s" .Spec.ServiceAccountName }}
            {{  end -}}
          {{- if isset .ObjectMeta.Annotations `sidecar.istio.io/userVolume` }}
          {{range $index, $value := fromJSON (index .ObjectMeta.Annotations `sidecar.istio.io/userVolume`) }}
        - name: "{{ $index }}"
          {{ toYaml $value | indent 2 }}
          {{ end }}
          {{ end }}
        {{- end }}
        {{- if and (eq .Values.global.proxy.tracer "lightstep") .Values.global.tracer.lightstep.cacertPath }}
        - name: lightstep-certs
          secret:
            optional: true
            secretName: lightstep.cacert
        {{- end }}
        {{- if .Values.global.podDNSSearchNamespaces }}
        dnsConfig:
          searches:
            {{- range .Values.global.podDNSSearchNamespaces }}
            - {{ render . }}
            {{- end }}
        {{- end }}
        podRedirectAnnot:
           sidecar.istio.io/interceptionMode: "{{ annotation .ObjectMeta `sidecar.istio.io/interceptionMode` .ProxyConfig.InterceptionMode }}"
           traffic.sidecar.istio.io/includeOutboundIPRanges: "{{ annotation .ObjectMeta `traffic.sidecar.istio.io/includeOutboundIPRanges` .Values.global.proxy.includeIPRanges }}"
           traffic.sidecar.istio.io/excludeOutboundIPRanges: "{{ annotation .ObjectMeta `traffic.sidecar.istio.io/excludeOutboundIPRanges` .Values.global.proxy.excludeIPRanges }}"
           traffic.sidecar.istio.io/includeInboundPorts: "{{ annotation .ObjectMeta `traffic.sidecar.istio.io/includeInboundPorts` (includeInboundPorts .Spec.Containers) }}"
           traffic.sidecar.istio.io/excludeInboundPorts: "{{ excludeInboundPort (annotation .ObjectMeta `status.sidecar.istio.io/port` .Values.global.proxy.statusPort) (annotation .ObjectMeta `traffic.sidecar.istio.io/excludeInboundPorts` .Values.global.proxy.excludeInboundPorts) }}"
        {{ if or (isset .ObjectMeta.Annotations `traffic.sidecar.istio.io/excludeOutboundPorts`) (ne .Values.global.proxy.excludeOutboundPorts "") }}
           traffic.sidecar.istio.io/excludeOutboundPorts: "{{ annotation .ObjectMeta `traffic.sidecar.istio.io/excludeOutboundPorts` .Values.global.proxy.excludeOutboundPorts }}"
        {{- end }}
           traffic.sidecar.istio.io/kubevirtInterfaces: "{{ index .ObjectMeta.Annotations `traffic.sidecar.istio.io/kubevirtInterfaces` }}"
      injectedAnnotations:
      EOF
    "values" = <<-EOF
      {"certmanager":{"enabled":false},"galley":{"enableAnalysis":false,"enableServiceDiscovery":false,"enabled":true,"global":{"arch":{"amd64":2,"ppc64le":2,"s390x":2},"certificates":[],"configValidation":true,"controlPlaneSecurityEnabled":false,"defaultNodeSelector":{},"defaultPodDisruptionBudget":{"enabled":true},"defaultResources":{"requests":{"cpu":"10m"}},"defaultTolerations":[],"disablePolicyChecks":false,"enableHelmTest":false,"enableTracing":true,"hub":"docker.io/istio","imagePullPolicy":"IfNotPresent","imagePullSecrets":[],"k8sIngress":{"enableHttps":false,"enabled":false,"gatewayName":"ingressgateway"},"localityLbSetting":{"enabled":true},"logging":{"level":"default:info"},"meshExpansion":{"enabled":false,"useILB":false},"meshID":"","meshNetworks":{},"monitoringPort":15014,"mtls":{"auto":true,"enabled":false},"multiCluster":{"clusterName":"","enabled":false},"network":"","oneNamespace":false,"operatorManageWebhooks":false,"outboundTrafficPolicy":{"mode":"ALLOW_ANY"},"policyCheckFailOpen":false,"priorityClassName":"","proxy":{"accessLogEncoding":"TEXT","accessLogFile":"/dev/stdout","accessLogFormat":"","autoInject":"enabled","clusterDomain":"cluster.local","componentLogLevel":"","concurrency":2,"dnsRefreshRate":"300s","enableCoreDump":false,"enableCoreDumpImage":"ubuntu:xenial","envoyAccessLogService":{"enabled":false,"tcpKeepalive":{"interval":"10s","probes":3,"time":"10s"},"tlsSettings":{"mode":"DISABLE","subjectAltNames":[]}},"envoyMetricsService":{"enabled":false,"tcpKeepalive":{"interval":"10s","probes":3,"time":"10s"},"tlsSettings":{"mode":"DISABLE","subjectAltNames":[]}},"envoyStatsd":{"enabled":false},"excludeIPRanges":"","excludeInboundPorts":"","excludeOutboundPorts":"","image":"proxyv2","includeIPRanges":"*","includeInboundPorts":"*","kubevirtInterfaces":"","logLevel":"","privileged":false,"protocolDetectionTimeout":"100ms","readinessFailureThreshold":30,"readinessInitialDelaySeconds":1,"readinessPeriodSeconds":2,"resources":{"limits":{"cpu":"2","memory":"1Gi"},"requests":{"cpu":"10m","memory":"40Mi"}},"statusPort":15020,"tracer":"zipkin"},"proxy_init":{"image":"proxyv2","resources":{"limits":{"cpu":"100m","memory":"50Mi"},"requests":{"cpu":"10m","memory":"10Mi"}}},"sds":{"enabled":false,"token":{"aud":"istio-ca"},"udsPath":""},"tag":"1.5.2","tracer":{"datadog":{"address":"$(HOST_IP):8126"},"lightstep":{"accessToken":"","address":"","cacertPath":"","secure":true},"stackdriver":{"debug":false,"maxNumberOfAnnotations":200,"maxNumberOfAttributes":200,"maxNumberOfMessageEvents":200},"zipkin":{"address":""}},"trustDomain":"","trustDomainAliases":[],"useMCP":true},"image":"galley","nodeSelector":{},"podAnnotations":{},"podAntiAffinityLabelSelector":[],"podAntiAffinityTermLabelSelector":[],"replicaCount":1,"rollingMaxSurge":"100%","rollingMaxUnavailable":"25%","tolerations":[]},"gateways":{"enabled":true,"global":{"arch":{"amd64":2,"ppc64le":2,"s390x":2},"certificates":[],"configValidation":true,"controlPlaneSecurityEnabled":false,"defaultNodeSelector":{},"defaultPodDisruptionBudget":{"enabled":true},"defaultResources":{"requests":{"cpu":"10m"}},"defaultTolerations":[],"disablePolicyChecks":false,"enableHelmTest":false,"enableTracing":true,"hub":"docker.io/istio","imagePullPolicy":"IfNotPresent","imagePullSecrets":[],"k8sIngress":{"enableHttps":false,"enabled":false,"gatewayName":"ingressgateway"},"localityLbSetting":{"enabled":true},"logging":{"level":"default:info"},"meshExpansion":{"enabled":false,"useILB":false},"meshID":"","meshNetworks":{},"monitoringPort":15014,"mtls":{"auto":true,"enabled":false},"multiCluster":{"clusterName":"","enabled":false},"network":"","oneNamespace":false,"operatorManageWebhooks":false,"outboundTrafficPolicy":{"mode":"ALLOW_ANY"},"policyCheckFailOpen":false,"priorityClassName":"","proxy":{"accessLogEncoding":"TEXT","accessLogFile":"/dev/stdout","accessLogFormat":"","autoInject":"enabled","clusterDomain":"cluster.local","componentLogLevel":"","concurrency":2,"dnsRefreshRate":"300s","enableCoreDump":false,"enableCoreDumpImage":"ubuntu:xenial","envoyAccessLogService":{"enabled":false,"tcpKeepalive":{"interval":"10s","probes":3,"time":"10s"},"tlsSettings":{"mode":"DISABLE","subjectAltNames":[]}},"envoyMetricsService":{"enabled":false,"tcpKeepalive":{"interval":"10s","probes":3,"time":"10s"},"tlsSettings":{"mode":"DISABLE","subjectAltNames":[]}},"envoyStatsd":{"enabled":false},"excludeIPRanges":"","excludeInboundPorts":"","excludeOutboundPorts":"","image":"proxyv2","includeIPRanges":"*","includeInboundPorts":"*","kubevirtInterfaces":"","logLevel":"","privileged":false,"protocolDetectionTimeout":"100ms","readinessFailureThreshold":30,"readinessInitialDelaySeconds":1,"readinessPeriodSeconds":2,"resources":{"limits":{"cpu":"2","memory":"1Gi"},"requests":{"cpu":"10m","memory":"40Mi"}},"statusPort":15020,"tracer":"zipkin"},"proxy_init":{"image":"proxyv2","resources":{"limits":{"cpu":"100m","memory":"50Mi"},"requests":{"cpu":"10m","memory":"10Mi"}}},"sds":{"enabled":false,"token":{"aud":"istio-ca"},"udsPath":""},"tag":"1.5.2","tracer":{"datadog":{"address":"$(HOST_IP):8126"},"lightstep":{"accessToken":"","address":"","cacertPath":"","secure":true},"stackdriver":{"debug":false,"maxNumberOfAnnotations":200,"maxNumberOfAttributes":200,"maxNumberOfMessageEvents":200},"zipkin":{"address":""}},"trustDomain":"","trustDomainAliases":[],"useMCP":true},"istio-egressgateway":{"autoscaleEnabled":false,"autoscaleMax":5,"autoscaleMin":1,"cpu":{"targetAverageUtilization":80},"enabled":true,"env":{"ISTIO_META_ROUTER_MODE":"standard"},"labels":{"app":"istio-egressgateway","istio":"egressgateway"},"nodeSelector":{},"podAnnotations":{},"podAntiAffinityLabelSelector":[],"podAntiAffinityTermLabelSelector":[],"ports":[{"name":"http2","port":80},{"name":"https","port":443},{"name":"tls","port":15443,"targetPort":15443}],"resources":{"limits":{"cpu":"2","memory":"1Gi"},"requests":{"cpu":"10m","memory":"40Mi"}},"rollingMaxSurge":"100%","rollingMaxUnavailable":"25%","secretVolumes":[{"mountPath":"/etc/istio/egressgateway-certs","name":"egressgateway-certs","secretName":"istio-egressgateway-certs"},{"mountPath":"/etc/istio/egressgateway-ca-certs","name":"egressgateway-ca-certs","secretName":"istio-egressgateway-ca-certs"}],"serviceAnnotations":{},"tolerations":[],"type":"ClusterIP"},"istio-ilbgateway":{"autoscaleEnabled":true,"autoscaleMax":5,"autoscaleMin":1,"cpu":{"targetAverageUtilization":80},"enabled":false,"labels":{"app":"istio-ilbgateway","istio":"ilbgateway"},"loadBalancerIP":"","nodeSelector":{},"podAnnotations":{},"ports":[{"name":"grpc-pilot-mtls","port":15011},{"name":"grpc-pilot","port":15010},{"name":"tcp-citadel-grpc-tls","port":8060,"targetPort":8060},{"name":"tcp-dns","port":5353}],"resources":{"requests":{"cpu":"800m","memory":"512Mi"}},"rollingMaxSurge":"100%","rollingMaxUnavailable":"25%","secretVolumes":[{"mountPath":"/etc/istio/ilbgateway-certs","name":"ilbgateway-certs","secretName":"istio-ilbgateway-certs"},{"mountPath":"/etc/istio/ilbgateway-ca-certs","name":"ilbgateway-ca-certs","secretName":"istio-ilbgateway-ca-certs"}],"serviceAnnotations":{"cloud.google.com/load-balancer-type":"internal"},"tolerations":[],"type":"LoadBalancer"},"istio-ingressgateway":{"autoscaleEnabled":false,"autoscaleMax":5,"autoscaleMin":1,"cpu":{"targetAverageUtilization":80},"enabled":true,"env":{"ISTIO_META_ROUTER_MODE":"standard"},"externalIPs":[],"labels":{"app":"istio-ingressgateway","istio":"ingressgateway"},"loadBalancerIP":"","loadBalancerSourceRanges":[],"meshExpansionPorts":[{"name":"tcp-pilot-grpc-tls","port":15011,"targetPort":15011},{"name":"tcp-mixer-grpc-tls","port":15004,"targetPort":15004},{"name":"tcp-citadel-grpc-tls","port":8060,"targetPort":8060},{"name":"tcp-dns-tls","port":853,"targetPort":853}],"nodeSelector":{},"podAnnotations":{},"podAntiAffinityLabelSelector":[],"podAntiAffinityTermLabelSelector":[],"ports":[{"name":"status-port","port":15020,"targetPort":15020},{"name":"http2","nodePort":31380,"port":80,"targetPort":80},{"name":"https","nodePort":31390,"port":443},{"name":"tcp","nodePort":31400,"port":31400},{"name":"https-kiali","port":15029,"targetPort":15029},{"name":"https-prometheus","port":15030,"targetPort":15030},{"name":"https-grafana","port":15031,"targetPort":15031},{"name":"https-tracing","port":15032,"targetPort":15032},{"name":"tls","port":15443,"targetPort":15443}],"resources":{"limits":{"cpu":"2","memory":"1Gi"},"requests":{"cpu":"10m","memory":"40Mi"}},"rollingMaxSurge":"100%","rollingMaxUnavailable":"25%","sds":{"enabled":false,"image":"node-agent-k8s","resources":{"limits":{"cpu":"2","memory":"1Gi"},"requests":{"cpu":"100m","memory":"128Mi"}}},"secretVolumes":[{"mountPath":"/etc/istio/ingressgateway-certs","name":"ingressgateway-certs","secretName":"istio-ingressgateway-certs"},{"mountPath":"/etc/istio/ingressgateway-ca-certs","name":"ingressgateway-ca-certs","secretName":"istio-ingressgateway-ca-certs"}],"serviceAnnotations":{},"tolerations":[],"type":"LoadBalancer"}},"global":{"arch":{"amd64":2,"ppc64le":2,"s390x":2},"certificates":[],"configValidation":true,"controlPlaneSecurityEnabled":false,"defaultNodeSelector":{},"defaultPodDisruptionBudget":{"enabled":true},"defaultResources":{"requests":{"cpu":"10m"}},"defaultTolerations":[],"disablePolicyChecks":false,"enableHelmTest":false,"enableTracing":true,"hub":"docker.io/istio","imagePullPolicy":"IfNotPresent","imagePullSecrets":[],"k8sIngress":{"enableHttps":false,"enabled":false,"gatewayName":"ingressgateway"},"localityLbSetting":{"enabled":true},"logging":{"level":"default:info"},"meshExpansion":{"enabled":false,"useILB":false},"meshID":"","meshNetworks":{},"monitoringPort":15014,"mtls":{"auto":true,"enabled":false},"multiCluster":{"clusterName":"","enabled":false},"network":"","oneNamespace":false,"operatorManageWebhooks":false,"outboundTrafficPolicy":{"mode":"ALLOW_ANY"},"policyCheckFailOpen":false,"priorityClassName":"","proxy":{"accessLogEncoding":"TEXT","accessLogFile":"/dev/stdout","accessLogFormat":"","autoInject":"enabled","clusterDomain":"cluster.local","componentLogLevel":"","concurrency":2,"dnsRefreshRate":"300s","enableCoreDump":false,"enableCoreDumpImage":"ubuntu:xenial","envoyAccessLogService":{"enabled":false,"host":null,"port":null,"tcpKeepalive":{"interval":"10s","probes":3,"time":"10s"},"tlsSettings":{"caCertificates":null,"clientCertificate":null,"mode":"DISABLE","privateKey":null,"sni":null,"subjectAltNames":[]}},"envoyMetricsService":{"enabled":false,"host":null,"port":null,"tcpKeepalive":{"interval":"10s","probes":3,"time":"10s"},"tlsSettings":{"caCertificates":null,"clientCertificate":null,"mode":"DISABLE","privateKey":null,"sni":null,"subjectAltNames":[]}},"envoyStatsd":{"enabled":false,"host":null,"port":null},"excludeIPRanges":"","excludeInboundPorts":"","excludeOutboundPorts":"","image":"proxyv2","includeIPRanges":"*","includeInboundPorts":"*","kubevirtInterfaces":"","logLevel":"","outlierLogPath":null,"privileged":false,"protocolDetectionTimeout":"100ms","readinessFailureThreshold":30,"readinessInitialDelaySeconds":1,"readinessPeriodSeconds":2,"resources":{"limits":{"cpu":"2","memory":"1Gi"},"requests":{"cpu":"10m","memory":"40Mi"}},"statusPort":15020,"tracer":"zipkin"},"proxy_init":{"image":"proxyv2","resources":{"limits":{"cpu":"100m","memory":"50Mi"},"requests":{"cpu":"10m","memory":"10Mi"}}},"sds":{"enabled":false,"token":{"aud":"istio-ca"},"udsPath":""},"tag":"1.5.2","tracer":{"datadog":{"address":"$(HOST_IP):8126"},"lightstep":{"accessToken":"","address":"","cacertPath":"","secure":true},"stackdriver":{"debug":false,"maxNumberOfAnnotations":200,"maxNumberOfAttributes":200,"maxNumberOfMessageEvents":200},"zipkin":{"address":""}},"trustDomain":"","trustDomainAliases":[],"useMCP":true},"grafana":{"accessMode":"ReadWriteMany","contextPath":"/grafana","dashboardProviders":{"dashboardproviders.yaml":{"apiVersion":1,"providers":[{"disableDeletion":false,"folder":"istio","name":"istio","options":{"path":"/var/lib/grafana/dashboards/istio"},"orgId":1,"type":"file"}]}},"datasources":{"datasources.yaml":{"apiVersion":1,"datasources":[{"access":"proxy","editable":true,"isDefault":true,"jsonData":{"timeInterval":"5s"},"name":"Prometheus","orgId":1,"type":"prometheus","url":"http://prometheus:9090"}]}},"enabled":true,"env":{},"envSecrets":{},"global":{"arch":{"amd64":2,"ppc64le":2,"s390x":2},"certificates":[],"configValidation":true,"controlPlaneSecurityEnabled":false,"defaultNodeSelector":{},"defaultPodDisruptionBudget":{"enabled":true},"defaultResources":{"requests":{"cpu":"10m"}},"defaultTolerations":[],"disablePolicyChecks":false,"enableHelmTest":false,"enableTracing":true,"hub":"docker.io/istio","imagePullPolicy":"IfNotPresent","imagePullSecrets":[],"k8sIngress":{"enableHttps":false,"enabled":false,"gatewayName":"ingressgateway"},"localityLbSetting":{"enabled":true},"logging":{"level":"default:info"},"meshExpansion":{"enabled":false,"useILB":false},"meshID":"","meshNetworks":{},"monitoringPort":15014,"mtls":{"auto":true,"enabled":false},"multiCluster":{"clusterName":"","enabled":false},"network":"","oneNamespace":false,"operatorManageWebhooks":false,"outboundTrafficPolicy":{"mode":"ALLOW_ANY"},"policyCheckFailOpen":false,"priorityClassName":"","proxy":{"accessLogEncoding":"TEXT","accessLogFile":"/dev/stdout","accessLogFormat":"","autoInject":"enabled","clusterDomain":"cluster.local","componentLogLevel":"","concurrency":2,"dnsRefreshRate":"300s","enableCoreDump":false,"enableCoreDumpImage":"ubuntu:xenial","envoyAccessLogService":{"enabled":false,"tcpKeepalive":{"interval":"10s","probes":3,"time":"10s"},"tlsSettings":{"mode":"DISABLE","subjectAltNames":[]}},"envoyMetricsService":{"enabled":false,"tcpKeepalive":{"interval":"10s","probes":3,"time":"10s"},"tlsSettings":{"mode":"DISABLE","subjectAltNames":[]}},"envoyStatsd":{"enabled":false},"excludeIPRanges":"","excludeInboundPorts":"","excludeOutboundPorts":"","image":"proxyv2","includeIPRanges":"*","includeInboundPorts":"*","kubevirtInterfaces":"","logLevel":"","privileged":false,"protocolDetectionTimeout":"100ms","readinessFailureThreshold":30,"readinessInitialDelaySeconds":1,"readinessPeriodSeconds":2,"resources":{"limits":{"cpu":"2","memory":"1Gi"},"requests":{"cpu":"10m","memory":"40Mi"}},"statusPort":15020,"tracer":"zipkin"},"proxy_init":{"image":"proxyv2","resources":{"limits":{"cpu":"100m","memory":"50Mi"},"requests":{"cpu":"10m","memory":"10Mi"}}},"sds":{"enabled":false,"token":{"aud":"istio-ca"},"udsPath":""},"tag":"1.5.2","tracer":{"datadog":{"address":"$(HOST_IP):8126"},"lightstep":{"accessToken":"","address":"","cacertPath":"","secure":true},"stackdriver":{"debug":false,"maxNumberOfAnnotations":200,"maxNumberOfAttributes":200,"maxNumberOfMessageEvents":200},"zipkin":{"address":""}},"trustDomain":"","trustDomainAliases":[],"useMCP":true},"image":{"repository":"grafana/grafana","tag":"6.4.3"},"ingress":{"annotations":{},"enabled":false,"hosts":["grafana.local"],"tls":[]},"nodeSelector":{},"persist":false,"podAntiAffinityLabelSelector":[],"podAntiAffinityTermLabelSelector":[],"replicaCount":1,"security":{"enabled":false,"passphraseKey":"passphrase","secretName":"grafana","usernameKey":"username"},"service":{"annotations":{},"externalPort":3000,"loadBalancerSourceRanges":[],"name":"http","type":"ClusterIP"},"storageClassName":"","tolerations":[]},"istio_cni":{"enabled":false},"istiocoredns":{"enabled":false},"kiali":{"contextPath":"/kiali","createDemoSecret":true,"dashboard":{"auth":{"strategy":"login"},"grafanaInClusterURL":"http://grafana:3000","jaegerInClusterURL":"http://tracing/jaeger","secretName":"kiali","viewOnlyMode":false},"enabled":true,"global":{"arch":{"amd64":2,"ppc64le":2,"s390x":2},"certificates":[],"configValidation":true,"controlPlaneSecurityEnabled":false,"defaultNodeSelector":{},"defaultPodDisruptionBudget":{"enabled":true},"defaultResources":{"requests":{"cpu":"10m"}},"defaultTolerations":[],"disablePolicyChecks":false,"enableHelmTest":false,"enableTracing":true,"hub":"docker.io/istio","imagePullPolicy":"IfNotPresent","imagePullSecrets":[],"k8sIngress":{"enableHttps":false,"enabled":false,"gatewayName":"ingressgateway"},"localityLbSetting":{"enabled":true},"logging":{"level":"default:info"},"meshExpansion":{"enabled":false,"useILB":false},"meshID":"","meshNetworks":{},"monitoringPort":15014,"mtls":{"auto":true,"enabled":false},"multiCluster":{"clusterName":"","enabled":false},"network":"","oneNamespace":false,"operatorManageWebhooks":false,"outboundTrafficPolicy":{"mode":"ALLOW_ANY"},"policyCheckFailOpen":false,"priorityClassName":"","proxy":{"accessLogEncoding":"TEXT","accessLogFile":"/dev/stdout","accessLogFormat":"","autoInject":"enabled","clusterDomain":"cluster.local","componentLogLevel":"","concurrency":2,"dnsRefreshRate":"300s","enableCoreDump":false,"enableCoreDumpImage":"ubuntu:xenial","envoyAccessLogService":{"enabled":false,"tcpKeepalive":{"interval":"10s","probes":3,"time":"10s"},"tlsSettings":{"mode":"DISABLE","subjectAltNames":[]}},"envoyMetricsService":{"enabled":false,"tcpKeepalive":{"interval":"10s","probes":3,"time":"10s"},"tlsSettings":{"mode":"DISABLE","subjectAltNames":[]}},"envoyStatsd":{"enabled":false},"excludeIPRanges":"","excludeInboundPorts":"","excludeOutboundPorts":"","image":"proxyv2","includeIPRanges":"*","includeInboundPorts":"*","kubevirtInterfaces":"","logLevel":"","privileged":false,"protocolDetectionTimeout":"100ms","readinessFailureThreshold":30,"readinessInitialDelaySeconds":1,"readinessPeriodSeconds":2,"resources":{"limits":{"cpu":"2","memory":"1Gi"},"requests":{"cpu":"10m","memory":"40Mi"}},"statusPort":15020,"tracer":"zipkin"},"proxy_init":{"image":"proxyv2","resources":{"limits":{"cpu":"100m","memory":"50Mi"},"requests":{"cpu":"10m","memory":"10Mi"}}},"sds":{"enabled":false,"token":{"aud":"istio-ca"},"udsPath":""},"tag":"1.5.2","tracer":{"datadog":{"address":"$(HOST_IP):8126"},"lightstep":{"accessToken":"","address":"","cacertPath":"","secure":true},"stackdriver":{"debug":false,"maxNumberOfAnnotations":200,"maxNumberOfAttributes":200,"maxNumberOfMessageEvents":200},"zipkin":{"address":""}},"trustDomain":"","trustDomainAliases":[],"useMCP":true},"hub":"quay.io/kiali","image":"kiali","ingress":{"annotations":{},"enabled":false,"hosts":["kiali.local"]},"nodeSelector":{},"podAnnotations":{},"podAntiAffinityLabelSelector":[],"podAntiAffinityTermLabelSelector":[],"prometheusAddr":"http://prometheus:9090","replicaCount":1,"security":{"cert_file":"/kiali-cert/cert-chain.pem","enabled":false,"private_key_file":"/kiali-cert/key.pem"},"tag":"v1.9","tolerations":[]},"mixer":{"adapters":{"kubernetesenv":{"enabled":true},"prometheus":{"enabled":true,"metricsExpiryDuration":"10m"},"stdio":{"enabled":true,"outputAsJson":true},"useAdapterCRDs":false},"env":{"GOMAXPROCS":"6"},"global":{"arch":{"amd64":2,"ppc64le":2,"s390x":2},"certificates":[],"configValidation":true,"controlPlaneSecurityEnabled":false,"defaultNodeSelector":{},"defaultPodDisruptionBudget":{"enabled":true},"defaultResources":{"requests":{"cpu":"10m"}},"defaultTolerations":[],"disablePolicyChecks":false,"enableHelmTest":false,"enableTracing":true,"hub":"docker.io/istio","imagePullPolicy":"IfNotPresent","imagePullSecrets":[],"k8sIngress":{"enableHttps":false,"enabled":false,"gatewayName":"ingressgateway"},"localityLbSetting":{"enabled":true},"logging":{"level":"default:info"},"meshExpansion":{"enabled":false,"useILB":false},"meshID":"","meshNetworks":{},"monitoringPort":15014,"mtls":{"auto":true,"enabled":false},"multiCluster":{"clusterName":"","enabled":false},"network":"","oneNamespace":false,"operatorManageWebhooks":false,"outboundTrafficPolicy":{"mode":"ALLOW_ANY"},"policyCheckFailOpen":false,"priorityClassName":"","proxy":{"accessLogEncoding":"TEXT","accessLogFile":"/dev/stdout","accessLogFormat":"","autoInject":"enabled","clusterDomain":"cluster.local","componentLogLevel":"","concurrency":2,"dnsRefreshRate":"300s","enableCoreDump":false,"enableCoreDumpImage":"ubuntu:xenial","envoyAccessLogService":{"enabled":false,"tcpKeepalive":{"interval":"10s","probes":3,"time":"10s"},"tlsSettings":{"mode":"DISABLE","subjectAltNames":[]}},"envoyMetricsService":{"enabled":false,"tcpKeepalive":{"interval":"10s","probes":3,"time":"10s"},"tlsSettings":{"mode":"DISABLE","subjectAltNames":[]}},"envoyStatsd":{"enabled":false},"excludeIPRanges":"","excludeInboundPorts":"","excludeOutboundPorts":"","image":"proxyv2","includeIPRanges":"*","includeInboundPorts":"*","kubevirtInterfaces":"","logLevel":"","privileged":false,"protocolDetectionTimeout":"100ms","readinessFailureThreshold":30,"readinessInitialDelaySeconds":1,"readinessPeriodSeconds":2,"resources":{"limits":{"cpu":"2","memory":"1Gi"},"requests":{"cpu":"10m","memory":"40Mi"}},"statusPort":15020,"tracer":"zipkin"},"proxy_init":{"image":"proxyv2","resources":{"limits":{"cpu":"100m","memory":"50Mi"},"requests":{"cpu":"10m","memory":"10Mi"}}},"sds":{"enabled":false,"token":{"aud":"istio-ca"},"udsPath":""},"tag":"1.5.2","tracer":{"datadog":{"address":"$(HOST_IP):8126"},"lightstep":{"accessToken":"","address":"","cacertPath":"","secure":true},"stackdriver":{"debug":false,"maxNumberOfAnnotations":200,"maxNumberOfAttributes":200,"maxNumberOfMessageEvents":200},"zipkin":{"address":""}},"trustDomain":"","trustDomainAliases":[],"useMCP":true},"image":"mixer","nodeSelector":{},"podAnnotations":{},"podAntiAffinityLabelSelector":[],"podAntiAffinityTermLabelSelector":[],"policy":{"autoscaleEnabled":false,"autoscaleMax":5,"autoscaleMin":1,"cpu":{"targetAverageUtilization":80},"enabled":true,"replicaCount":1,"resources":{"requests":{"cpu":"10m","memory":"100Mi"}},"rollingMaxSurge":"100%","rollingMaxUnavailable":"25%"},"telemetry":{"autoscaleEnabled":false,"autoscaleMax":5,"autoscaleMin":1,"cpu":{"targetAverageUtilization":80},"enabled":true,"loadshedding":{"latencyThreshold":"100ms","mode":"enforce"},"replicaCount":1,"reportBatchMaxEntries":100,"reportBatchMaxTime":"1s","resources":{"limits":{"cpu":"4800m","memory":"4G"},"requests":{"cpu":"50m","memory":"100Mi"}},"rollingMaxSurge":"100%","rollingMaxUnavailable":"25%","sessionAffinityEnabled":false},"tolerations":[]},"nodeagent":{"enabled":false},"pilot":{"autoscaleEnabled":false,"autoscaleMax":5,"autoscaleMin":1,"configSource":{},"cpu":{"targetAverageUtilization":80},"enableProtocolSniffingForInbound":false,"enableProtocolSniffingForOutbound":true,"enabled":true,"env":{"PILOT_PUSH_THROTTLE":100},"global":{"arch":{"amd64":2,"ppc64le":2,"s390x":2},"certificates":[],"configValidation":true,"controlPlaneSecurityEnabled":false,"defaultNodeSelector":{},"defaultPodDisruptionBudget":{"enabled":true},"defaultResources":{"requests":{"cpu":"10m"}},"defaultTolerations":[],"disablePolicyChecks":false,"enableHelmTest":false,"enableTracing":true,"hub":"docker.io/istio","imagePullPolicy":"IfNotPresent","imagePullSecrets":[],"k8sIngress":{"enableHttps":false,"enabled":false,"gatewayName":"ingressgateway"},"localityLbSetting":{"enabled":true},"logging":{"level":"default:info"},"meshExpansion":{"enabled":false,"useILB":false},"meshID":"","meshNetworks":{},"monitoringPort":15014,"mtls":{"auto":true,"enabled":false},"multiCluster":{"clusterName":"","enabled":false},"network":"","oneNamespace":false,"operatorManageWebhooks":false,"outboundTrafficPolicy":{"mode":"ALLOW_ANY"},"policyCheckFailOpen":false,"priorityClassName":"","proxy":{"accessLogEncoding":"TEXT","accessLogFile":"/dev/stdout","accessLogFormat":"","autoInject":"enabled","clusterDomain":"cluster.local","componentLogLevel":"","concurrency":2,"dnsRefreshRate":"300s","enableCoreDump":false,"enableCoreDumpImage":"ubuntu:xenial","envoyAccessLogService":{"enabled":false,"tcpKeepalive":{"interval":"10s","probes":3,"time":"10s"},"tlsSettings":{"mode":"DISABLE","subjectAltNames":[]}},"envoyMetricsService":{"enabled":false,"tcpKeepalive":{"interval":"10s","probes":3,"time":"10s"},"tlsSettings":{"mode":"DISABLE","subjectAltNames":[]}},"envoyStatsd":{"enabled":false},"excludeIPRanges":"","excludeInboundPorts":"","excludeOutboundPorts":"","image":"proxyv2","includeIPRanges":"*","includeInboundPorts":"*","kubevirtInterfaces":"","logLevel":"","privileged":false,"protocolDetectionTimeout":"100ms","readinessFailureThreshold":30,"readinessInitialDelaySeconds":1,"readinessPeriodSeconds":2,"resources":{"limits":{"cpu":"2","memory":"1Gi"},"requests":{"cpu":"10m","memory":"40Mi"}},"statusPort":15020,"tracer":"zipkin"},"proxy_init":{"image":"proxyv2","resources":{"limits":{"cpu":"100m","memory":"50Mi"},"requests":{"cpu":"10m","memory":"10Mi"}}},"sds":{"enabled":false,"token":{"aud":"istio-ca"},"udsPath":""},"tag":"1.5.2","tracer":{"datadog":{"address":"$(HOST_IP):8126"},"lightstep":{"accessToken":"","address":"","cacertPath":"","secure":true},"stackdriver":{"debug":false,"maxNumberOfAnnotations":200,"maxNumberOfAttributes":200,"maxNumberOfMessageEvents":200},"zipkin":{"address":""}},"trustDomain":"","trustDomainAliases":[],"useMCP":true},"image":"pilot","keepaliveMaxServerConnectionAge":"30m","nodeSelector":{},"podAnnotations":{},"podAntiAffinityLabelSelector":[],"podAntiAffinityTermLabelSelector":[],"resources":{"requests":{"cpu":"10m","memory":"100Mi"}},"rollingMaxSurge":"100%","rollingMaxUnavailable":"25%","sidecar":true,"tolerations":[],"traceSampling":100},"prometheus":{"contextPath":"/prometheus","enabled":true,"global":{"arch":{"amd64":2,"ppc64le":2,"s390x":2},"certificates":[],"configValidation":true,"controlPlaneSecurityEnabled":false,"defaultNodeSelector":{},"defaultPodDisruptionBudget":{"enabled":true},"defaultResources":{"requests":{"cpu":"10m"}},"defaultTolerations":[],"disablePolicyChecks":false,"enableHelmTest":false,"enableTracing":true,"hub":"docker.io/istio","imagePullPolicy":"IfNotPresent","imagePullSecrets":[],"k8sIngress":{"enableHttps":false,"enabled":false,"gatewayName":"ingressgateway"},"localityLbSetting":{"enabled":true},"logging":{"level":"default:info"},"meshExpansion":{"enabled":false,"useILB":false},"meshID":"","meshNetworks":{},"monitoringPort":15014,"mtls":{"auto":true,"enabled":false},"multiCluster":{"clusterName":"","enabled":false},"network":"","oneNamespace":false,"operatorManageWebhooks":false,"outboundTrafficPolicy":{"mode":"ALLOW_ANY"},"policyCheckFailOpen":false,"priorityClassName":"","proxy":{"accessLogEncoding":"TEXT","accessLogFile":"/dev/stdout","accessLogFormat":"","autoInject":"enabled","clusterDomain":"cluster.local","componentLogLevel":"","concurrency":2,"dnsRefreshRate":"300s","enableCoreDump":false,"enableCoreDumpImage":"ubuntu:xenial","envoyAccessLogService":{"enabled":false,"tcpKeepalive":{"interval":"10s","probes":3,"time":"10s"},"tlsSettings":{"mode":"DISABLE","subjectAltNames":[]}},"envoyMetricsService":{"enabled":false,"tcpKeepalive":{"interval":"10s","probes":3,"time":"10s"},"tlsSettings":{"mode":"DISABLE","subjectAltNames":[]}},"envoyStatsd":{"enabled":false},"excludeIPRanges":"","excludeInboundPorts":"","excludeOutboundPorts":"","image":"proxyv2","includeIPRanges":"*","includeInboundPorts":"*","kubevirtInterfaces":"","logLevel":"","privileged":false,"protocolDetectionTimeout":"100ms","readinessFailureThreshold":30,"readinessInitialDelaySeconds":1,"readinessPeriodSeconds":2,"resources":{"limits":{"cpu":"2","memory":"1Gi"},"requests":{"cpu":"10m","memory":"40Mi"}},"statusPort":15020,"tracer":"zipkin"},"proxy_init":{"image":"proxyv2","resources":{"limits":{"cpu":"100m","memory":"50Mi"},"requests":{"cpu":"10m","memory":"10Mi"}}},"sds":{"enabled":false,"token":{"aud":"istio-ca"},"udsPath":""},"tag":"1.5.2","tracer":{"datadog":{"address":"$(HOST_IP):8126"},"lightstep":{"accessToken":"","address":"","cacertPath":"","secure":true},"stackdriver":{"debug":false,"maxNumberOfAnnotations":200,"maxNumberOfAttributes":200,"maxNumberOfMessageEvents":200},"zipkin":{"address":""}},"trustDomain":"","trustDomainAliases":[],"useMCP":true},"hub":"docker.io/prom","image":"prometheus","ingress":{"enabled":false,"hosts":["prometheus.local"]},"nodeSelector":{},"podAntiAffinityLabelSelector":[],"podAntiAffinityTermLabelSelector":[],"replicaCount":1,"retention":"6h","scrapeInterval":"15s","security":{"enabled":true},"service":{"annotations":{},"nodePort":{"enabled":false,"port":32090}},"tag":"v2.12.0","tolerations":[]},"security":{"citadelHealthCheck":false,"createMeshPolicy":true,"enableNamespacesByDefault":true,"enabled":true,"env":{},"global":{"arch":{"amd64":2,"ppc64le":2,"s390x":2},"certificates":[],"configValidation":true,"controlPlaneSecurityEnabled":false,"defaultNodeSelector":{},"defaultPodDisruptionBudget":{"enabled":true},"defaultResources":{"requests":{"cpu":"10m"}},"defaultTolerations":[],"disablePolicyChecks":false,"enableHelmTest":false,"enableTracing":true,"hub":"docker.io/istio","imagePullPolicy":"IfNotPresent","imagePullSecrets":[],"k8sIngress":{"enableHttps":false,"enabled":false,"gatewayName":"ingressgateway"},"localityLbSetting":{"enabled":true},"logging":{"level":"default:info"},"meshExpansion":{"enabled":false,"useILB":false},"meshID":"","meshNetworks":{},"monitoringPort":15014,"mtls":{"auto":true,"enabled":false},"multiCluster":{"clusterName":"","enabled":false},"network":"","oneNamespace":false,"operatorManageWebhooks":false,"outboundTrafficPolicy":{"mode":"ALLOW_ANY"},"policyCheckFailOpen":false,"priorityClassName":"","proxy":{"accessLogEncoding":"TEXT","accessLogFile":"/dev/stdout","accessLogFormat":"","autoInject":"enabled","clusterDomain":"cluster.local","componentLogLevel":"","concurrency":2,"dnsRefreshRate":"300s","enableCoreDump":false,"enableCoreDumpImage":"ubuntu:xenial","envoyAccessLogService":{"enabled":false,"tcpKeepalive":{"interval":"10s","probes":3,"time":"10s"},"tlsSettings":{"mode":"DISABLE","subjectAltNames":[]}},"envoyMetricsService":{"enabled":false,"tcpKeepalive":{"interval":"10s","probes":3,"time":"10s"},"tlsSettings":{"mode":"DISABLE","subjectAltNames":[]}},"envoyStatsd":{"enabled":false},"excludeIPRanges":"","excludeInboundPorts":"","excludeOutboundPorts":"","image":"proxyv2","includeIPRanges":"*","includeInboundPorts":"*","kubevirtInterfaces":"","logLevel":"","privileged":false,"protocolDetectionTimeout":"100ms","readinessFailureThreshold":30,"readinessInitialDelaySeconds":1,"readinessPeriodSeconds":2,"resources":{"limits":{"cpu":"2","memory":"1Gi"},"requests":{"cpu":"10m","memory":"40Mi"}},"statusPort":15020,"tracer":"zipkin"},"proxy_init":{"image":"proxyv2","resources":{"limits":{"cpu":"100m","memory":"50Mi"},"requests":{"cpu":"10m","memory":"10Mi"}}},"sds":{"enabled":false,"token":{"aud":"istio-ca"},"udsPath":""},"tag":"1.5.2","tracer":{"datadog":{"address":"$(HOST_IP):8126"},"lightstep":{"accessToken":"","address":"","cacertPath":"","secure":true},"stackdriver":{"debug":false,"maxNumberOfAnnotations":200,"maxNumberOfAttributes":200,"maxNumberOfMessageEvents":200},"zipkin":{"address":""}},"trustDomain":"","trustDomainAliases":[],"useMCP":true},"image":"citadel","nodeSelector":{},"podAnnotations":{},"podAntiAffinityLabelSelector":[],"podAntiAffinityTermLabelSelector":[],"replicaCount":1,"rollingMaxSurge":"100%","rollingMaxUnavailable":"25%","selfSigned":true,"tolerations":[],"workloadCertTtl":"2160h"},"sidecarInjectorWebhook":{"alwaysInjectSelector":[],"enableNamespacesByDefault":false,"enabled":true,"global":{"arch":{"amd64":2,"ppc64le":2,"s390x":2},"certificates":[],"configValidation":true,"controlPlaneSecurityEnabled":false,"defaultNodeSelector":{},"defaultPodDisruptionBudget":{"enabled":true},"defaultResources":{"requests":{"cpu":"10m"}},"defaultTolerations":[],"disablePolicyChecks":false,"enableHelmTest":false,"enableTracing":true,"hub":"docker.io/istio","imagePullPolicy":"IfNotPresent","imagePullSecrets":[],"k8sIngress":{"enableHttps":false,"enabled":false,"gatewayName":"ingressgateway"},"localityLbSetting":{"enabled":true},"logging":{"level":"default:info"},"meshExpansion":{"enabled":false,"useILB":false},"meshID":"","meshNetworks":{},"monitoringPort":15014,"mtls":{"auto":true,"enabled":false},"multiCluster":{"clusterName":"","enabled":false},"network":"","oneNamespace":false,"operatorManageWebhooks":false,"outboundTrafficPolicy":{"mode":"ALLOW_ANY"},"policyCheckFailOpen":false,"priorityClassName":"","proxy":{"accessLogEncoding":"TEXT","accessLogFile":"/dev/stdout","accessLogFormat":"","autoInject":"enabled","clusterDomain":"cluster.local","componentLogLevel":"","concurrency":2,"dnsRefreshRate":"300s","enableCoreDump":false,"enableCoreDumpImage":"ubuntu:xenial","envoyAccessLogService":{"enabled":false,"tcpKeepalive":{"interval":"10s","probes":3,"time":"10s"},"tlsSettings":{"mode":"DISABLE","subjectAltNames":[]}},"envoyMetricsService":{"enabled":false,"tcpKeepalive":{"interval":"10s","probes":3,"time":"10s"},"tlsSettings":{"mode":"DISABLE","subjectAltNames":[]}},"envoyStatsd":{"enabled":false},"excludeIPRanges":"","excludeInboundPorts":"","excludeOutboundPorts":"","image":"proxyv2","includeIPRanges":"*","includeInboundPorts":"*","kubevirtInterfaces":"","logLevel":"","privileged":false,"protocolDetectionTimeout":"100ms","readinessFailureThreshold":30,"readinessInitialDelaySeconds":1,"readinessPeriodSeconds":2,"resources":{"limits":{"cpu":"2","memory":"1Gi"},"requests":{"cpu":"10m","memory":"40Mi"}},"statusPort":15020,"tracer":"zipkin"},"proxy_init":{"image":"proxyv2","resources":{"limits":{"cpu":"100m","memory":"50Mi"},"requests":{"cpu":"10m","memory":"10Mi"}}},"sds":{"enabled":false,"token":{"aud":"istio-ca"},"udsPath":""},"tag":"1.5.2","tracer":{"datadog":{"address":"$(HOST_IP):8126"},"lightstep":{"accessToken":"","address":"","cacertPath":"","secure":true},"stackdriver":{"debug":false,"maxNumberOfAnnotations":200,"maxNumberOfAttributes":200,"maxNumberOfMessageEvents":200},"zipkin":{"address":""}},"trustDomain":"","trustDomainAliases":[],"useMCP":true},"image":"sidecar_injector","injectedAnnotations":{},"neverInjectSelector":[],"nodeSelector":{},"podAnnotations":{},"podAntiAffinityLabelSelector":[],"podAntiAffinityTermLabelSelector":[],"replicaCount":1,"rewriteAppHTTPProbe":true,"rollingMaxSurge":"100%","rollingMaxUnavailable":"25%","tolerations":[]},"tracing":{"enabled":true,"global":{"arch":{"amd64":2,"ppc64le":2,"s390x":2},"certificates":[],"configValidation":true,"controlPlaneSecurityEnabled":false,"defaultNodeSelector":{},"defaultPodDisruptionBudget":{"enabled":true},"defaultResources":{"requests":{"cpu":"10m"}},"defaultTolerations":[],"disablePolicyChecks":false,"enableHelmTest":false,"enableTracing":true,"hub":"docker.io/istio","imagePullPolicy":"IfNotPresent","imagePullSecrets":[],"k8sIngress":{"enableHttps":false,"enabled":false,"gatewayName":"ingressgateway"},"localityLbSetting":{"enabled":true},"logging":{"level":"default:info"},"meshExpansion":{"enabled":false,"useILB":false},"meshID":"","meshNetworks":{},"monitoringPort":15014,"mtls":{"auto":true,"enabled":false},"multiCluster":{"clusterName":"","enabled":false},"network":"","oneNamespace":false,"operatorManageWebhooks":false,"outboundTrafficPolicy":{"mode":"ALLOW_ANY"},"policyCheckFailOpen":false,"priorityClassName":"","proxy":{"accessLogEncoding":"TEXT","accessLogFile":"/dev/stdout","accessLogFormat":"","autoInject":"enabled","clusterDomain":"cluster.local","componentLogLevel":"","concurrency":2,"dnsRefreshRate":"300s","enableCoreDump":false,"enableCoreDumpImage":"ubuntu:xenial","envoyAccessLogService":{"enabled":false,"tcpKeepalive":{"interval":"10s","probes":3,"time":"10s"},"tlsSettings":{"mode":"DISABLE","subjectAltNames":[]}},"envoyMetricsService":{"enabled":false,"tcpKeepalive":{"interval":"10s","probes":3,"time":"10s"},"tlsSettings":{"mode":"DISABLE","subjectAltNames":[]}},"envoyStatsd":{"enabled":false},"excludeIPRanges":"","excludeInboundPorts":"","excludeOutboundPorts":"","image":"proxyv2","includeIPRanges":"*","includeInboundPorts":"*","kubevirtInterfaces":"","logLevel":"","privileged":false,"protocolDetectionTimeout":"100ms","readinessFailureThreshold":30,"readinessInitialDelaySeconds":1,"readinessPeriodSeconds":2,"resources":{"limits":{"cpu":"2","memory":"1Gi"},"requests":{"cpu":"10m","memory":"40Mi"}},"statusPort":15020,"tracer":"zipkin"},"proxy_init":{"image":"proxyv2","resources":{"limits":{"cpu":"100m","memory":"50Mi"},"requests":{"cpu":"10m","memory":"10Mi"}}},"sds":{"enabled":false,"token":{"aud":"istio-ca"},"udsPath":""},"tag":"1.5.2","tracer":{"datadog":{"address":"$(HOST_IP):8126"},"lightstep":{"accessToken":"","address":"","cacertPath":"","secure":true},"stackdriver":{"debug":false,"maxNumberOfAnnotations":200,"maxNumberOfAttributes":200,"maxNumberOfMessageEvents":200},"zipkin":{"address":""}},"trustDomain":"","trustDomainAliases":[],"useMCP":true},"ingress":{"enabled":false},"jaeger":{"accessMode":"ReadWriteMany","hub":"docker.io/jaegertracing","image":"all-in-one","memory":{"max_traces":50000},"persist":false,"podAnnotations":{},"spanStorageType":"badger","storageClassName":"","tag":1.16},"nodeSelector":{},"podAntiAffinityLabelSelector":[],"podAntiAffinityTermLabelSelector":[],"provider":"jaeger","service":{"annotations":{},"externalPort":80,"name":"http","type":"ClusterIP"},"tolerations":[],"zipkin":{"hub":"docker.io/openzipkin","image":"zipkin","javaOptsHeap":700,"maxSpans":500000,"node":{"cpus":2},"podAnnotations":{},"probeStartupDelay":200,"queryPort":9411,"resources":{"limits":{"cpu":"300m","memory":"900Mi"},"requests":{"cpu":"150m","memory":"900Mi"}},"tag":"2.14.2"}}}
      EOF
  }
  metadata {
    labels = {
      "app"      = "istio"
      "chart"    = "istio"
      "heritage" = "Tiller"
      "istio"    = "sidecar-injector"
      "release"  = "istio"
    }
    name      = "istio-sidecar-injector"
    namespace = var.namespace
  }
}