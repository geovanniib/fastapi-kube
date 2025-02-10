provider "helm" {
  kubernetes {
    config_path = "../config/config-k3s"
  }

  # registry {
  #   url      = "oci://localhost:5000"
  #   username = "username"
  #   password = "password"
  # }

  # registry {
  #   url      = "oci://private.registry"
  #   username = "username"
  #   password = "password"
  # }
}




terraform {
  required_providers {
    kubernetes = {
        source = "hashicorp/kubernetes"
        version = ">= 2.0"
    }

    helm = {
        source = "hashicorp/helm"
        version = ">= 2.0, < 3.0"
    }
  }

  backend "kubernetes" {
    secret_suffix    = "state-log"
    config_path      = "../config/config-k3s"
  }
}


