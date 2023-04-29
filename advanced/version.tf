# set the version of the terraform helm provider
terraform {
  required_version = ">= 0.14.0"

  required_providers {
    helm = {
      source = "hashicorp/helm"
      version = "~> 2.9.0"
    }
    datadog = {
      source = "datadog/datadog"
    }
  }
}