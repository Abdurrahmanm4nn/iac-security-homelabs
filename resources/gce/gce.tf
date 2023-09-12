# Create a VM
resource "google_compute_instance" "vm_instance" {
  name         = "terraform-vm-instance"
  machine_type = var.gce_instance
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
    }
  }
}