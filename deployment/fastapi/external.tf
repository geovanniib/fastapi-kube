

# Define ConfigMap or Secret for Nginx configuration (optional)
resource "kubernetes_config_map" "nginx_config" {
  metadata {
    name = "nginx-config"
  }

  data = {
    "nginx.conf" = file("../../nginx.conf")
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
              memory = "40Mi"
              cpu    = "20m"
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


  depends_on = [ kubernetes_config_map.nginx_config ]
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
      port        = var.nginx_port
      target_port = 80
    }

    type = "LoadBalancer"
  }
}


