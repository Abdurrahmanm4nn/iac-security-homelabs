# create a new VPC
resource "google_compute_network" "vpc_network" {
  name = var.vpc_name
}