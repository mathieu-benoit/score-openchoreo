{{/* remove default generated manifests */}}
{{ $workloadNames := keys .Workloads }}
{{ range $i, $m := (reverse .Manifests) }}
{{ if or (eq $m.kind "Namespace") (and (or (eq $m.kind "Deployment") (eq $m.kind "Service")) (has $m.metadata.name $workloadNames)) }}
{{ $i := sub (len $.Manifests) (add $i 1) }}
- op: delete
  path: {{ $i }}
{{ end }}
{{ end }}

{{/* generate OpenChoreo's Project if --generate-namespace is supplied */}}
{{ $namespace := .Namespace }}
{{ range $i, $m := .Manifests }}
{{ if eq $m.kind "Namespace" }}
- op: set
  path: -1
  value:
    apiVersion: openchoreo.dev/v1alpha1
    kind: Project
    metadata:
      annotations:
        openchoreo.dev/description: {{ $namespace }}
        openchoreo.dev/display-name: {{ $namespace }}
      labels:
        openchoreo.dev/name: {{ $namespace }}
      name: {{ $namespace }}
      namespace: {{ $namespace }}
    spec:
      deploymentPipelineRef:
        name: default
{{ end }}
{{ end }}

{{/* generate OpenChoreo's Component per Workload */}}
{{ range $name, $spec := .Workloads }}
{{ $service := $spec.service }}
{{ $firstContainerName := index (keys $spec.containers) 0 }}
{{ $firstContainer := get $spec.containers $firstContainerName }}
- op: set
  path: -1
  value:
    apiVersion: openchoreo.dev/v1alpha1
    kind: Component
    metadata:
      name: {{ $name }}
      namespace: {{ $namespace }}
    spec:
      owner:
        projectName: {{ $namespace }}
      componentType:
        kind: ClusterComponentType
        name: deployment/service
      autoDeploy: true
- op: set
  path: -1
  value:
    apiVersion: openchoreo.dev/v1alpha1
    kind: Workload
    metadata:
      name: {{ $name }}
      namespace: {{ $namespace }}
    spec:
      owner:
        componentName: {{ $name }}
        projectName: {{ $namespace }}
      endpoints:
        {{- range $portName, $port := $service.ports }}
        {{ $portName }}:
          port: {{ $port.port }}
          {{ if eq $portName "grpc" }}
          type: "gRPC"
          {{ else }}
          type: "HTTP"
          {{ end }}  
        {{ end }}
      container:
        image: {{ $firstContainer.image }}
        env:
          {{- range $variableName, $variableValue := $firstContainer.variables }}
          - key: {{ $variableName }}
            value: {{ $variableValue }}
          {{ end }}
{{ end }}