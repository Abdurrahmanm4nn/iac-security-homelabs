# Configure kubernetes provider with Oauth2 access token.
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/client_config
# This fetches a new token, which will expire in 1 hour.
data "google_client_config" "default" {}

provider "kubernetes" {
  host = "https://${module.gke_web_cluster.cluster_endpoint}"

  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke_web_cluster.cluster_ca_certificate)

  alias = "Web-Cluster"
}

module "vulnerable-web" {
  source       = "./gke-services/dvwa"
  address_name = "rmn-dvwa"
  region       = var.region
  project      = var.project
  network_tier = "PREMIUM"

  providers = {
    kubernetes = kubernetes.Web-Cluster
  }
}