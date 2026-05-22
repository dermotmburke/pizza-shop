{{/*
Common labels
*/}}
{{- define "pizza-shop.labels" -}}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Common app environment variables
*/}}
{{- define "pizza-shop.appEnv" -}}
- name: DD_AGENT_HOST
  valueFrom:
    fieldRef:
      fieldPath: status.hostIP
- name: SPRING_KAFKA_BOOTSTRAP_SERVERS
  value: {{ .Values.kafka.bootstrapServers }}
- name: SPRING_KAFKA_SECURITY_PROTOCOL
  value: {{ .Values.kafka.securityProtocol | quote }}
- name: SPRING_KAFKA_SSL_TRUST_STORE_LOCATION
  value: {{ .Values.kafka.truststoreLocation | quote }}
- name: SPRING_KAFKA_SSL_TRUST_STORE_PASSWORD
  value: {{ .Values.kafka.truststorePassword | quote }}
- name: SPRING_KAFKA_SSL_TRUST_STORE_TYPE
  value: {{ .Values.kafka.truststoreType | quote }}
- name: SPRING_KAFKA_PROPERTIES_SASL_MECHANISM
  value: {{ .Values.kafka.saslMechanism | quote }}
- name: SPRING_KAFKA_PROPERTIES_SASL_JAAS_CONFIG
  value: {{ .Values.kafka.saslJaasConfig | quote }}
- name: MANAGEMENT_TRACING_EXPORT_ZIPKIN_ENDPOINT
  value: http://$(DD_AGENT_HOST):{{ .Values.datadog.agentZipkinPort }}/api/v2/spans
{{- end }}
