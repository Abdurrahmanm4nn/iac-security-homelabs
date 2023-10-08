module "gke_siem_cluster" {
  source       = "./modules/gke"
  project      = var.project
  zone         = "us-west1-a"
  cluster_name = "gke-siem-cluster"

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  node_count               = 1

  network    = module.vpc-network.vpc_name
  subnetwork = module.vpc-network.vpc_name
}

module "gke_siem_nodepool" {
  source           = "./modules/gke-node-pool"
  project          = var.project
  zone             = "us-west1-a"
  cluster_name     = module.gke_siem_cluster.cluster_name
  version_prefix   = "1.27."
  gke_machine_type = "e2-standard-8"
  node_count       = 1

  depends_on = [
    module.gke_siem_cluster,
    module.vpc-subnet,
    module.vpc-network
  ]
}