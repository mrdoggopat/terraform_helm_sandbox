# this provides the helm provider access to your kubernetes cluster
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

# you can change configurations here
locals {
    agent_settings = {
      clusterName = "terrablecluster"
      tag = "terraform:sandbox"
      tlsVerify = false
      logs_enabled = true
      logs_containerCollectAll = true //log collection
      dogstatsd_port = var.datadog_dogstatsd_port
      apm_portEnabled = true
      apm_port = var.datadog_apm_port
      orchestratorExplorer_enabled = true
      processAgent_enabled = true
      processCollection = true
      networkMonitoring = true
      agent_volume_name = "redis"
      agent_volumeMount_name = "redis"
      agent_volume_hostPath = "/var/log"
      agent_volumeMount_mountPath = "/var/log/test"
      clusterAgent_enabled = true
      clusterAgent_clusterChecks_enabled = true
      clusterAgent_kubeStateMetricsCore_enabled = true
      clusterAgent_metricsProvider_enabled = true
      clusterAgent_useDatadogMetrics = true
    }
}

# resource that creates the datadog helm chart
resource "helm_release" "datadog_agent" {
    name             = var.release_name
    chart            = "datadog"
    repository       = "https://helm.datadoghq.com"
    version          = var.datadog_helm_version
    namespace        = var.namespace

    set_sensitive {
        name  = "datadog.apiKey"
        value = var.datadog_api_key
    }

    set_sensitive {
        name  = "datadog.appKey"
        value = var.datadog_app_key
    }

    #cluster name
    set {
        name  = "datadog.clusterName"
        value = local.agent_settings.clusterName
    }

    #add a tag
    set {
        name  = "datadog.tags[0]"
        value = local.agent_settings.tag
    }

    #avoid minikube kubelet errors
    set {
        name  = "datadog.kubelet.tlsVerify"
        value = local.agent_settings.tlsVerify
    }

    #enable logs
    set {
        name  = "datadog.logs.enabled"
        value = local.agent_settings.logs_enabled
    }

    set {
        name  = "datadog.logs.containerCollectAll"
        value = local.agent_settings.logs_containerCollectAll
    }

    #set the dogstatsd port
    set {
        name  = "datadog.dogstatsd.port"
        value = local.agent_settings.dogstatsd_port
    }

    #enable apm via TCP
    set {
        name  = "datadog.apm.portEnabled"
        value = local.agent_settings.apm_portEnabled
    }

    #set the apm port
    set {
        name  = "datadog.apm.port"
        value = local.agent_settings.apm_port
    }

    #enable orchestrator explorer
    set {
        name  = "datadog.orchestratorExplorer.enabled"
        value = local.agent_settings.orchestratorExplorer_enabled
    }

    #enable process agent for live containers
    set {
        name  = "datadog.processAgent.enabled"
        value = local.agent_settings.processAgent_enabled
    }

    #enable live processes
    set {
        name  = "datadog.processAgent.processCollection"
        value = local.agent_settings.processCollection
    }

    #enable network performance monitoring
    set {
        name  = "datadog.networkMonitoring.enabled"
        value = local.agent_settings.networkMonitoring
    }

    #set volumes in the agent daemonset
    set {
        name  = "agents.volumes[0].name"
        value = local.agent_settings.agent_volume_name
    }

    set {
        name  = "agents.volumes[0].hostPath.path"
        value = local.agent_settings.agent_volume_hostPath
    }

    #set volumemounts in the agent daemonset
    set {
        name  = "agents.volumeMounts[0].name"
        value = local.agent_settings.agent_volumeMount_name
    }

    set {
        name  = "agents.volumeMounts[0].mountPath"
        value = local.agent_settings.agent_volumeMount_mountPath
    }

    #enable the cluster agent
    set {
        name  = "clusterAgent.enabled"
        value = local.agent_settings.clusterAgent_enabled
    }

    #enable clusterchecks
    set {
        name  = "datadog.clusterChecks.enabled"
        value = local.agent_settings.clusterAgent_clusterChecks_enabled
    }

    #enable ksm core
    set {
        name  = "datadog.kubeStateMetricsCore.enabled"
        value = local.agent_settings.clusterAgent_kubeStateMetricsCore_enabled
    }

    #enable cluster agent external metrics with hpa
    set {
        name  = "clusterAgent.metricsProvider.enabled"
        value = local.agent_settings.clusterAgent_metricsProvider_enabled
    }

    #enable datadogmetric crd
    set {
        name  = "clusterAgent.metricsProvider.useDatadogMetrics"
        value = local.agent_settings.clusterAgent_useDatadogMetrics
    }
}