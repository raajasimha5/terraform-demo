resource "google_compute_instance" "default" {
  # Use the count meta-argument to create multiple instances.
  count = var.vm_instance_count

  # Use variables from variables.tf
  project      = var.gcp_project_id
  zone         = var.gcp_zone
  name         = "${lower(var.vm_instance_name)}-${count.index}"
  machine_type = var.vm_machine_type

  # Defines the boot disk and the image to use for the VM.
  boot_disk {
    initialize_params {
      image = var.vm_image
    }
  }

  # This network interface is required to allow the VM to have network access.
  # It will be attached to the 'default' VPC network.
  network_interface {
    network = google_compute_network.custom_vpc.name

    # An empty access_config block assigns an ephemeral public IP.
    access_config {}
  }
}
