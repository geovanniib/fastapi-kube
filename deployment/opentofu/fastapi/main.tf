resource "kubernetes_secret" "docker_registry" {
  metadata {
    name = "docker-registry-secret"
  }

  data = {
    ".dockerconfigjson" = "${file("~/.docker/config.json")}"
  }

  type = "kubernetes.io/dockerconfigjson"
}





# API service (Node.js or any other application)
resource "kubernetes_deployment" "api" {
  metadata {
    name = "api"
    labels = {
      app = "api"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "api"
      }
    }

    template {
      metadata {
        labels = {
          app = "api"
        }
      }

      spec {
        container {
          name  = "api"
          image = var.api_image_name
          resources {
            limits = {
              memory = var.api_mem_limit
              cpu    = var.api_cpu_limit
            }
            requests = {
              memory = var.api_mem_request
              cpu    = var.api_cpu_request
            }            
          }
          port {
            container_port = 8000
          }
          env {
            name  = "MIN_LOG_LEVEL"
            value = var.min_log_level
          }
          env {
            name  = "HOST"
            value = var.api_host
          }
          env {
            name  = "PORT"
            value = var.api_port
          }
          env {
            name  = "REDIS_HOST"
            value = "mem-db-service"
          }
          env {
            name  = "REDIS_PORT"
            value = "6379"
          }

          env {
            name  = "API_DELAY_MIN"
            value = var.api_delay_min
          }

          env {
            name  = "API_DELAY_MAX"
            value = var.api_delay_max
          }



          liveness_probe {
            http_get {
              path = "/color"
              port = 8000
            }

            failure_threshold = 5
            period_seconds = 5
          }

          startup_probe {
            http_get {
              path = "/color"
              port = 8000
            }

            failure_threshold = 3
            period_seconds = 30
          }

          readiness_probe {
            
            http_get {
              path = "/color"
              port = 8000
            }

            failure_threshold = 3
            period_seconds = 5

          }

        }

        image_pull_secrets {
            name = kubernetes_secret.docker_registry.metadata[0].name
        }


      }
    }
  }
}

resource "kubernetes_service" "api_service" {
  metadata {
    name = "api"
  }

  spec {
    selector = {
      app = "api"
    }
    port {
      port        = 8000
      target_port = 8000
    }
  }
}

# Worker service (Worker container)
resource "kubernetes_deployment" "worker" {
  metadata {
    name = "worker"
    labels = {
      app = "worker"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "worker"
      }
    }

    template {
      metadata {
        labels = {
          app = "worker"
        }
      }

      spec {
        container {
          name  = "worker"
          image = var.worker_image_name
          resources {
            limits = {
              memory = var.worker_mem_limit
              cpu    = var.worker_cpu_limit
            }
            requests = {
              memory = var.worker_mem_request
              cpu    = var.worker_cpu_request
            }               
          }
          port {
            container_port = 8000
          }
          env {
            name  = "MIN_LOG_LEVEL"
            value = var.min_log_level
          }
          env {
            name  = "REDIS_HOST"
            value = "mem-db-service"
          }
          env {
            name  = "REDIS_PORT"
            value = "6379"
          }
          env {
            name  = "POSTGRES_HOST"
            value = "sql-db-service"
          }
          env {
            name  = "POSTGRES_PORT"
            value = "5432"
          }
          env {
            name  = "POSTGRES_USER"
            value = "pguser"
          }
          env {
            name  = "POSTGRES_PASSWORD"
            value = "pgpwd"
          }
          env {
            name  = "POSTGRES_DB"
            value = "dev"
          }


          env {
            name  = "WORKER_DELAY_MIN"
            value = var.worker_delay_min
          }

          env {
            name  = "WORKER_DELAY_MAX"
            value = var.worker_delay_max
          }





          liveness_probe {
            http_get {
              path = "/worker"
              port = 8000
            }

            failure_threshold = 5
            period_seconds = 5
          }

          startup_probe {
            http_get {
              path = "/worker"
              port = 8000
            }

            failure_threshold = 3
            period_seconds = 30
          }

          readiness_probe {
            
            http_get {
              path = "/worker"
              port = 8000
            }

            failure_threshold = 3
            period_seconds = 5

          }


          
        }


        image_pull_secrets {
            name = kubernetes_secret.docker_registry.metadata[0].name
        }
      }
    }
  }
}

resource "kubernetes_service" "worker_service" {
  metadata {
    name = "worker"
  }

  spec {
    selector = {
      app = "worker"
    }
    port {
      port        = 8000
      target_port = 8000
    }
  }
}








