# Define Terraform variables for API and Worker settings
variable "api_image_name" {
  type    = string
  default = "ghcr.io/geovanniib/color_api:latest"
}

variable "worker_image_name" {
  type    = string
  default = "ghcr.io/geovanniib/color_worker:latest"
}

variable "min_log_level" {
  type    = string
  default = "info"
}

variable "api_host" {
  type    = string
  default = "0.0.0.0"
}

variable "api_port" {
  type    = string
  default = "8000"
}


# docker credentials

# variable "docker_username" {
#   description = "Docker Registry Username"
#   type        = string
# }

# variable "docker_password" {
#   description = "Docker Registry Password"
#   type        = string
#   sensitive   = true
# }

# variable "docker_email" {
#   description = "Docker Registry Email"
#   type        = string
# }