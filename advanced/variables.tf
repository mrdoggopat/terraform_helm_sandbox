variable "datadog_api_key" {
  type        = string
  description = "Datadog API Key"
  default     = "<your_api_key>"
  sensitive   = true
}

variable "datadog_app_key" {
  type        = string
  description = "Datadog Application Key"
  default     = "<your_app_key>"
  sensitive   = true
}

variable "module_enabled" {
  type        = bool
  default     = true
  description = "Set to false to prevent the module from creating any resources"
}

variable "release_name" {
  type        = string
  default     = "datadog"
  description = "Datadog release name. for usage with namespaces use Ex. datadog-agent-namespace"
}

variable "datadog_helm_version" {
  type        = string
  default     = "3.27.0"
  description = "Datadog Helm chart version 3.27.0"
}

variable "namespace" {
  type        = string
  default     = "default"
  description = "Namespace for creating any resources associated with datadog"
}

variable "datadog_dogstatsd_port" {
  type        = number
  default     = 8125
  description = "DogstatsD port, set this to custom value for each namespace. For cluster level leave default"
}

variable "datadog_apm_port" {
  type        = number
  default     = 8126
  description = "datadog apm port, set this to custom value for each namespace. For cluster level leave default"
}
