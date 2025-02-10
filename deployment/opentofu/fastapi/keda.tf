
# KEDA ScaledObject for API
resource "kubernetes_manifest" "api_scaledobject" {
  manifest = {
    apiVersion = "keda.sh/v1alpha1"
    kind       = "ScaledObject"
    metadata = {
      name = "api-scaler"
      namespace = "default"
    }
    spec = {
      scaleTargetRef = {
        name = kubernetes_deployment.api.metadata[0].name
        # kind = Deployment
      }


      pollingInterval = 10                          
      cooldownPeriod = 60

      minReplicaCount = 1
      maxReplicaCount = 3    

      triggers = [
        {
          type = "cpu"
          metricType= "Utilization"
          metadata = {
            "value" = "80"  # This could be adjusted based on your desired metric (e.g., CPU usage percentage)
          }
        }
      ]
    }
  }


  
}




# KEDA ScaledObject for Worker
resource "kubernetes_manifest" "worker_scaledobject" {
  manifest = {
    apiVersion = "keda.sh/v1alpha1"
    kind       = "ScaledObject"
    metadata = {
      name = "worker-scaler"
      namespace = "default"
    }
    spec = {
      scaleTargetRef = {
        name = kubernetes_deployment.worker.metadata[0].name
        # kind = Deployment
      }

      pollingInterval = 10                          
      cooldownPeriod = 60

      minReplicaCount = 1
      maxReplicaCount = 3    

      triggers = [
        {
          type = "cpu"
          metricType= "Utilization"
          metadata = {
            "value" = "80"  # This could be adjusted based on your desired metric (e.g., CPU usage percentage)
          }
        }
      ]
    }
  }

  
}


