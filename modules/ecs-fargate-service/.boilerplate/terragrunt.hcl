terraform {
  source = "{{ .sourceUrl }}"
}

include "root" {
  path = find_in_parent_folders()
}

inputs = {
  # --------------------------------------------------------------------------------------------------------------------
  # Required input variables
  # --------------------------------------------------------------------------------------------------------------------
  {{ range .requiredVariables }}
  # Description: {{ .Description }}
  # Type: {{ .Type }}
  {{ .Name }} = {{ .DefaultValuePlaceholder }}  # TODO: fill in value
  {{ end }}

  # --------------------------------------------------------------------------------------------------------------------
  # Optional input variables
  # Uncomment the ones you wish to set
  # --------------------------------------------------------------------------------------------------------------------
  {{ range .optionalVariables }}
  # Description: {{ .Description }}
  # Type: {{ .Type }}
  # {{ .Name }} = {{ .DefaultValue }}
  {{ end }}
}