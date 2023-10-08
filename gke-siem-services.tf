provider "kubernetes" {
  host = "https://${module.gke_siem_cluster.cluster_endpoint}"

  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke_siem_cluster.cluster_ca_certificate)

  alias = "SIEM-Cluster"
}

module "elastic-siem" {
  source       = "./gke-services/elastic"
  address_name = "rmn-siem"
  region       = "us-west1"
  project      = var.project
  network_tier = "PREMIUM"
  elastic_port = 8080
  kibana_port  = 8081

  providers = {
    kubernetes = kubernetes.SIEM-Cluster
  }
}