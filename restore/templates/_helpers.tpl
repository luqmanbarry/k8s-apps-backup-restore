{{/*
Expand the name of the chart.fullname
*/}}
{{- define "restore.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "restore.fullname" -}}
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
{{- define "restore.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/*
GitOps Labels
*/}}
{{- define "restore.gitopsLabels" -}}
app.kubernetes.io/part-of: oadp-backup-restore
argocd.argoproj.io/managed-by: openshift-gitops
{{- end }}

{{/*
Common labels
*/}}
{{- define "restore.labels" -}}
helm.sh/chart: {{ include "restore.chart" . }}
{{ include "restore.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "restore.selectorLabels" -}}
app.kubernetes.io/name: {{ include "restore.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "restore.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "restore.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "restore.namespace" }}
{{- .Release.Namespace | trunc 63 | trimSuffix "-" }}
{{- end }}
