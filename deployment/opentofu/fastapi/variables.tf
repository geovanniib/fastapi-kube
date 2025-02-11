# Define Terraform variables for API and Worker settings


##------------------- EXTERNAL APPLICATION PORT (localhost)
variable "nginx_port" {
  type    = string
  default = "3000"
}


##------------------- RESOURCE VARIABLES

# api
variable "api_cpu_request" {
  description = "The CPU request for the api container"
  type        = string
  default     = "25m"  # Example: 500m (millicores), can also use 1, 2, etc.
}

variable "api_mem_request" {
  description = "The memory request for the api container"
  type        = string
  default     = "50Mi" # Example: 512Mi (mebibytes)
}

variable "api_cpu_limit" {
  description = "The CPU limit for the api container"
  type        = string
  default     = "150m"  # Example: 1 CPU core
}

variable "api_mem_limit" {
  description = "The memory limit for the api container"
  type        = string
  default     = "100Mi" # Example: 1Gi (gigabyte)
}


# worker
variable "worker_cpu_request" {
  description = "The CPU request for the worker container"
  type        = string
  default     = "25m"  # Example: 500m (millicores), can also use 1, 2, etc.
}

variable "worker_mem_request" {
  description = "The memory request for the worker container"
  type        = string
  default     = "50Mi" # Example: 512Mi (mebibytes)
}

variable "worker_cpu_limit" {
  description = "The CPU limit for the worker container"
  type        = string
  default     = "150m"  # Example: 1 CPU core
}

variable "worker_mem_limit" {
  description = "The memory limit for the worker container"
  type        = string
  default     = "100Mi" # Example: 1Gi (gigabyte)
}



##---------------------- CONTAINER VARIABLES
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
  default = "DEBUG"
}

variable "api_host" {
  type    = string
  default = "0.0.0.0"
}

variable "api_port" {
  type    = string
  default = "8000"
}






#---------- DELAY VARIABLES

variable "api_delay_min" {
  type    = string
  default = "100"
}


variable "api_delay_max" {
  type    = string
  default = "150"
}

variable "worker_delay_min" {
  type    = string
  default = "100"
}


variable "worker_delay_max" {
  type    = string
  default = "150"
}



# STORAGE VARIABLES


