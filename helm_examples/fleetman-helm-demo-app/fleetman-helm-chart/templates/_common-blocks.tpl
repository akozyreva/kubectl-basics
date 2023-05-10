 # file for common templates
{{ define "webappImage" }}
        # identation must be saved for this example! 0_0
      - name: webapp
          # Note to deployer - add -dev at the end of here for development version
          # example of string function
        image: {{ .Values.doсkerRepoName | lower }}/k8s-fleetman-helm-demo:v1.0.0{{ if .Values.development }}-dev{{ end }}
{{ end }}

{{ define "webappImageWithoutHardcodedIdentation" }}
- name: webapp
  # Note to deployer - add -dev at the end of here for development version
  # example of string function
  image: {{ .Values.doсkerRepoName | lower }}/k8s-fleetman-helm-demo:v1.0.0{{ if .Values.development }}-dev{{ end }}
{{ end }}