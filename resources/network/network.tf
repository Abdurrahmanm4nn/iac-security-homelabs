# create a new VPC
resource "google_compute_network" "vpc_network" {
  name = "terraform-vpc"
}

# Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "labs-subnet"
  region        = var.region
  network       = google_compute_network.vpc_network.name
  ip_cidr_range = "10.10.0.0/24"
}