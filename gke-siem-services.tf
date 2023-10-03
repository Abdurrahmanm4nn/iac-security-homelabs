provider "kubernetes" {
  host = "https://${module.gke_siem_cluster.cluster_endpoint}"

  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke_siem_cluster.cluster_ca_certificate)

  alias = "SIEM-Cluster"
}

module "elastic-siem" {
  source       = "./gke-services/elastic"
  address_name = "rmn-siem"
  region       = var.region
  project      = var.project
  network_tier = "PREMIUM"
  elastic_port = 8080
  kibana_port  = 80

  providers = {
    kubernetes = kubernetes.SIEM-Cluster
  }
}

module "nginx-siem" {
  source = "./gke-services/nginx"
  service_name = module.elastic-siem.kibana_service
  service_port = module.elastic-siem.kibana_port

  providers = {
    kubernetes = kubernetes.SIEM-Cluster
  }
}