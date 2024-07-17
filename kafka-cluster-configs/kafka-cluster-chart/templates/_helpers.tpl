{{- define "kafka.fullname" -}}
{{- printf "%s-%s" .Release.Name .Values.global.clusterName | trunc 63 | trimSuffix "-" -}}
{{- end -}}
