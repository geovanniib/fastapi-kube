provider "kubernetes" {
  config_path = "../config/config-k3s"
}


provider "helm" {
  kubernetes {
    config_path = "../config/config-k3s"
  }
}


terraform {
  required_providers {
    kubernetes = {
        source = "hashicorp/kubernetes"
        version = ">= 2.0"
    }
  }

  backend "kubernetes" {
    secret_suffix    = "state"
    config_path      = "../config/config-k3s"
  }
}


