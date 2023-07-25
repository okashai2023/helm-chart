{{/*
Expand the name of the chart.
*/}}
{{- define "service.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "service.fullname" -}}
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
{{- define "service.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "service.labels" -}}
app.kubernetes.io/name: {{ include "service.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
meta.helm.sh/release-name: {{ .Release.Name }}
meta.helm.sh/release-namespace: {{ .Release.Namespace }}
{{- end }}

{{/*
datadog labels
*/}}
{{- define "datadog.labels" -}}
{{- if .Values.datadog.enabled -}}
tags.datadoghq.com/env: {{ .Release.Namespace }}
tags.datadoghq.com/service: {{ include "service.name" . }}
tags.datadoghq.com/version: {{ (split "_" .Values.image.tag)._2 }}
{{- end -}}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "service.selectorLabels" -}}
app.kubernetes.io/name: {{ include "service.name" . }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "service.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "service.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
