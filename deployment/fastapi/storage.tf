resource "kubernetes_config_map" "sql_schema" {
  metadata {
    name = "sql-schema"
  }

  data = {
    "000_schema.sql" = file("../../db/000_schema.sql")
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

          volume_mount {
            name = "init-db-volume"
            mount_path = "/docker-entrypoint-initdb.d/000_schema.sql"
            sub_path   = "000_schema.sql"
          }          
        }

        volume {
          name = "init-db-volume"
          config_map {
            name = "sql-schema"
          }
        }

      }
    }
  }


  depends_on = [ kubernetes_config_map.sql_schema ]
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
              cpu    = "1024m"
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



