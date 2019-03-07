{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "solr.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "solr.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "solr.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Define solr cloud name.
*/}}
{{- define "solr.cloud-name" -}}
{{- .Release.Name | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Define the name of the secret of ACL creds  to connect to Zookeeper
*/}}
{{- define "solr.acl-name" -}}
{{- printf "%s-%s" .Release.Name "zkacl" | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{/*
Define the name of the headless service for solr
*/}}
{{- define "solr.headless-service-name" -}}
{{- printf "%s-%s" .Release.Name "hs" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Define the name of the pod disruption budget for solr
*/}}
{{- define "solr.pod-disruption-budget-name" -}}
{{- printf "%s-%s" .Release.Name "pdb" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Define the name of the security config map for solr
*/}}
{{- define "solr.security-config-map" -}}
{{- printf "%s-%s" .Release.Name "security" | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{/*
Define the name of the LoadBalancer service for solr
*/}}
{{- define "solr.loadbalancer-service-name" -}}
{{- printf "%s-%s" .Release.Name "lb" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
  Define the labels that should be used by selectors
*/}}
{{- define "solr.selector" -}}
app: {{ template "solr.name" . }}
solrcloud: {{ template "solr.cloud-name" . }}
{{- end -}}

{{/*
  Define the labels that should be applied to all resources in the chart
*/}}
{{- define "solr.labels" -}}
app: {{ template "solr.name" . }}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
solrcloud: {{ template "solr.cloud-name" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}