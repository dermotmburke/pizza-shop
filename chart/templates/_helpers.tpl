{{/*
Common labels
*/}}
{{- define "pizza-shop.labels" -}}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Selector labels for a given component
*/}}
{{- define "pizza-shop.selectorLabels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/component: {{ .component }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Image reference
*/}}
{{- define "pizza-shop.image" -}}
{{ .Values.image.registry }}/{{ .Values.image.repository }}/{{ .artifact }}:{{ .Values.image.tag }}
{{- end }}

{{/*
Common app environment variables
*/}}
{{- define "pizza-shop.appEnv" -}}
- name: SPRING_KAFKA_BOOTSTRAP_SERVERS
  value: {{ .Release.Name }}-kafka:9092
- name: MANAGEMENT_TRACING_EXPORT_ZIPKIN_ENDPOINT
  value: http://{{ .Release.Name }}-zipkin:9411/api/v2/spans
{{- end }}
