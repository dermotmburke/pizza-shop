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
- name: SPRING_KAFKA_BOOTSTRAP_SERVERS
  value: {{ .Values.kafka.bootstrapServers }}
- name: MANAGEMENT_TRACING_EXPORT_ZIPKIN_ENDPOINT
  value: {{ .Values.zipkin.endpoint }}
{{- end }}
