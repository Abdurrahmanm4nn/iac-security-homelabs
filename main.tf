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

# Configure kubernetes provider with Oauth2 access token.
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/client_config
# This fetches a new token, which will expire in 1 hour.
data "google_client_config" "default" {}

data "google_container_cluster" "my_cluster" {
  name     = "${var.project}-gke"
  location = var.region
  project = var.project
}

provider "kubernetes" {
  host = data.google_container_cluster.my_cluster.endpoint

  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(data.google_container_cluster.my_cluster.master_auth[0].cluster_ca_certificate)
}