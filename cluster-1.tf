module "gke" {
  source  = "./modules/gke"
  project = var.project
  region  = var.region
  cluster_name = "terraform-gke-cluster-1"

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  node_count       = 1

  network    = module.vpc-network.vpc_name
  subnetwork = module.vpc-subnet.name
}

module "gke-node-pool" {
  source       = "./modules/gke-node-pool"
  project      = var.project
  region       = var.region
  cluster_name = module.gke.cluster_name
  version_prefix = "1.27."
  node_count   = 1

  depends_on = [
    module.gke,
    module.vpc-subnet,
    module.vpc-network
  ]
}