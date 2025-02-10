output "nginx_service_port" {
  value = kubernetes_service.nginx_service.spec[0].port[0].port
  description = "The port used by the nginx service"
}



output "endpoint_health_api" {
  value = "http://localhost:${kubernetes_service.nginx_service.spec[0].port[0].port}/color"
  description = "The health endpoint for the api"
}

output "endpoint_health_worker" {
  value = "http://localhost:${kubernetes_service.nginx_service.spec[0].port[0].port}/worker"
  description = "The health endpoint for the worker"
}



output "endpoint_colors_names" {
  value = "http://localhost:${kubernetes_service.nginx_service.spec[0].port[0].port}/color/names"
  description = "The API of color names"
}


output "endpoint_color_example" {
  value = "http://localhost:${kubernetes_service.nginx_service.spec[0].port[0].port}/color/match?name=green"
  description = "An example of an API"
}