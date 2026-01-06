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

  network_interface {

    network = var.network_name

    access_config {

      // Ephemeral public IP

    }

  }
 
  
}
