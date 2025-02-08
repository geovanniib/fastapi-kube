resource "kubernetes_secret" "docker_registry" {
  metadata {
    name = "docker-registry-secret"
  }

  # data = {
  #   ".dockerconfigjson" = base64encode(jsonencode({
  #     auths = {
  #       "ghcr.io"= {
  #         # username = var.docker_username
  #         # password = var.docker_password
  #         # email    = var.docker_email
  #       }
  #     }
  #   }))
  # }

  data = {
    ".dockerconfigjson" = "${file("~/.docker/config.json")}"
  }

  type = "kubernetes.io/dockerconfigjson"
}



# Define ConfigMap or Secret for Nginx configuration (optional)
resource "kubernetes_config_map" "nginx_config" {
  metadata {
    name = "nginx-config"
  }

  data = {
    "nginx.conf" = file("../../nginx.conf")
  }
}


resource "kubernetes_deployment" "mem_db" {
  metadata {
    name = "mem-db"
    labels = {
      app = "mem-db"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "mem-db"
      }
    }

    template {
      metadata {
        labels = {
          app = "mem-db"
        }
      }

      spec {
        container {
          name  = "mem-db"
          image = "redis:7-alpine"
          resources {
            limits = {
              memory = "500Mi"
              cpu    = "1"
            }
          }
          port {
            container_port = 6379
          }
          env {
            name  = "REDIS_HOST"
            value = "mem-db"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "mem_db_service" {
  metadata {
    name = "mem-db-service"
  }

  spec {
    selector = {
      app = "mem-db"
    }
    port {
      port        = 6379
      target_port = 6379
    }
  }
}

# SQL_DB service (PostgreSQL)
resource "kubernetes_deployment" "sql_db" {
  metadata {
    name = "sql-db"
    labels = {
      app = "sql-db"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "sql-db"
      }
    }

    template {
      metadata {
        labels = {
          app = "sql-db"
        }
      }

      spec {
        container {
          name  = "sql-db"
          image = "postgres:17-alpine"
          resources {
            limits = {
              memory = "1Gi"
              cpu    = "1"
            }
          }
          port {
            container_port = 5432
          }
          env {
            name  = "POSTGRES_HOST_AUTH_METHOD"
            value = "trust"
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
        }
      }
    }
  }
}

resource "kubernetes_service" "sql_db_service" {
  metadata {
    name = "sql-db-service"
  }

  spec {
    selector = {
      app = "sql-db"
    }
    port {
      port        = 5432
      target_port = 5432
    }
  }
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
              memory = "384Mi"
              cpu    = "0.384"
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
            value = "mem-db"
          }
          env {
            name  = "REDIS_PORT"
            value = "6379"
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
              memory = "384Mi"
              cpu    = "0.384"
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
            value = "mem-db"
          }
          env {
            name  = "REDIS_PORT"
            value = "6379"
          }
          env {
            name  = "POSTGRES_HOST"
            value = "sql-db"
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

# NGINX Service for Load Balancer
resource "kubernetes_deployment" "nginx" {
  metadata {
    name = "nginx"
    labels = {
      app = "nginx"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "nginx"
      }
    }

    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }

      spec {
        container {
          name  = "nginx"
          image = "nginx:1-alpine"
          resources {
            limits = {
              memory = "256Mi"
              cpu    = "0.512"
            }
          }
          port {
            container_port = 80
          }
          volume_mount {
            name = "nginx-volume"
            mount_path = "/etc/nginx/nginx.conf"
            sub_path   = "nginx.conf"
          }
        }

      volume {
        name = "nginx-volume"
        config_map {
          name = "nginx-config"
        }
      }
      }
    }
  }
}

resource "kubernetes_service" "nginx_service" {
  metadata {
    name = "nginx-service"
  }

  spec {
    selector = {
      app = "nginx"
    }
    port {
      port        = 8000
      target_port = 80
    }

    type = "LoadBalancer"
  }
}



