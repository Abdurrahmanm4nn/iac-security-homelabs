# Create a VM
resource "google_compute_instance" "vm_instance_template" {
  name         = var.name
  machine_type = var.gce_instance
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = var.image_os
    }
  }

  network_interface {
    network = var.vpc_network
  }
}