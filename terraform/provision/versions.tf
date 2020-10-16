terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "3.43.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = "1.3.2"
    }
    github = {
      source = "hashicorp/github"
      version = "3.1.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "1.13.2"
    }
    tls = {
      source = "hashicorp/tls"
      version = "3.0.0"
    }
  }
  required_version = ">= 0.13"
}
