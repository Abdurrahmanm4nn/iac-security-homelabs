# Terraform settings
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.80.0" # optional
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.23.0"
    }
  }
}

# GCP provider (plugin) configuration
provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
}