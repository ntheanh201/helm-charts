{{/*
Expand the name of the chart.
*/}}
{{- define "nvitop-exporter.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "nvitop-exporter.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "nvitop-exporter.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "nvitop-exporter.labels" -}}
helm.sh/chart: {{ include "nvitop-exporter.chart" . }}
{{ include "nvitop-exporter.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "nvitop-exporter.selectorLabels" -}}
app.kubernetes.io/name: {{ include "nvitop-exporter.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "nvitop-exporter.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "nvitop-exporter.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the nvitop-exporter command args
*/}}
{{- define "nvitop-exporter.args" -}}
- "--bind-address={{ .Values.nvitopExporter.bindAddress }}"
- "--port={{ .Values.nvitopExporter.port }}"
{{- if .Values.nvitopExporter.interval }}
- "--interval={{ .Values.nvitopExporter.interval }}"
{{- end }}
{{- range .Values.nvitopExporter.extraArgs }}
- {{ . | quote }}
{{- end }}
{{- end }} 