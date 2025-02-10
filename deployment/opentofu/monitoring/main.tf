# Loki - Prometheus-compatible logs storage system
resource "helm_release" "loki_stack" {
  name       = "loki"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "loki-stack"
  version    = "2.10.2"  # Set the appropriate version
  namespace  = "monitoring"
  create_namespace = "true"

#   values = [
#     file("values_loki.yaml") # Optional: Add your custom values file for Loki configuration
#   ]

  set {
    name  = "grafana.enabled"
    value = "true"
  }

  set {
    name  = "grafana.service.enabled"
    value = "true"
  }




  set {
    name  = "grafana.service.port"
    value = var.grafana_port
  }

  set {
    name  = "grafana.service.targetPort"
    value = "3000"
  }

  set {
    name  = "grafana.service.type"
    value = "LoadBalancer"
  }
}


